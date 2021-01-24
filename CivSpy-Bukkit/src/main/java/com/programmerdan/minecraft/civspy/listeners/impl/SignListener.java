package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.Location;
import org.bukkit.block.Block;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.block.SignChangeEvent;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;

/**
 * Contributes <code>player.sign.change</code> including the text of the sign. 
 * Individual lines are limited to 100 characters for sanity.
 * 
 * @author ProgrammerDan
 *
 */
public class SignListener extends ServerDataListener {

	public SignListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}

	@Override
	public void shutdown() {
		// NO-OP
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void changeEvent(SignChangeEvent event) {
		try {
			Player player = event.getPlayer();
			if (player == null) return;
			UUID uuid = player.getUniqueId();

			Location location = player.getLocation();
			
			Block onBlock = event.getBlock();
			if (onBlock != null) {
				location = onBlock.getLocation();
			}
			
			if (location == null) {
				return;
			}
			Chunk chunk = location.getChunk();
			
			StringBuilder sb = new StringBuilder('[');
			String[] lines = event.getLines();
			for (int i = 0; i < lines.length; i++) {
				if (lines[i] == null) {
					continue;
				}
				if (lines[i].length() > 100) {
					sb.append(lines[i].substring(0, 100));
				} else {
					sb.append(lines[i]);
				}
				if (i < lines.length - 1) {
					sb.append(',');
				}
			}
			sb.append(']');
			
			DataSample edit = new PointDataSample("player.sign.edit",
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					sb.toString());
			this.record(edit);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Sign Edit Event in CivSpy", e);
		}
	}
}
