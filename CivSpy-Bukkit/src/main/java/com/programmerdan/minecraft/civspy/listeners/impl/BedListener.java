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
import org.bukkit.event.player.PlayerBedEnterEvent;
import org.bukkit.event.player.PlayerBedLeaveEvent;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;
import com.programmerdan.minecraft.civspy.util.ItemStackToString;

/**
 * <code>player.bed.enter.RESULT</code> and <code>player.bed.leave</code> 
 * 
 * includes player and nature of bed
 * 
 * @author ProgrammerDan
 *
 */
public class BedListener extends ServerDataListener {

	public BedListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}

	@Override
	public void shutdown() {
		// NO-OP
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void enterEvent(PlayerBedEnterEvent enterEvent) {
		try {
			Player player = enterEvent.getPlayer();
			if (player == null) return;
			UUID uuid = player.getUniqueId();

			Location location = null;
			
			Block onBlock = enterEvent.getBed();
			if (onBlock != null) {
				location = onBlock.getLocation();
			} else {
				return;
			}
			
			if (location == null) {
				location = player.getLocation();
			}
			
			if (location == null) {
				return;
			}
			Chunk chunk = location.getChunk();
			
		
			DataSample enter = new PointDataSample("player.bed.enter." + enterEvent.getBedEnterResult().toString(),
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(onBlock.getState()));
			this.record(enter);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Bed Enter Event in CivSpy", e);
		}
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void leaveEvent(PlayerBedLeaveEvent leaveEvent) {
		try {
			Player player = leaveEvent.getPlayer();
			if (player == null) return;
			UUID uuid = player.getUniqueId();

			Location location = null;
			
			Block onBlock = leaveEvent.getBed();
			if (onBlock != null) {
				location = onBlock.getLocation();
			} else {
				return;
			}
			
			if (location == null) {
				location = player.getLocation();
			}
			
			if (location == null) {
				return;
			}
			Chunk chunk = location.getChunk();
			
			DataSample leave = new PointDataSample("player.bed.leave", this.getServer(),
					chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(onBlock.getState()));
			this.record(leave);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Bed Leave Event in CivSpy", e);
		}
	}
}
