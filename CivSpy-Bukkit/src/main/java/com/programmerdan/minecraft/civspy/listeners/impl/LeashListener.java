package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.entity.Entity;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.player.PlayerUnleashEntityEvent;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;

/**
 * <code>player.unleash.REASON</code> where REASON is the reason for the unleashing.  
 * 
 * includes player and nature of entity getting unleashed in string data.
 * 
 * @author ProgrammerDan
 *
 */
public class LeashListener extends ServerDataListener {

	public LeashListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}

	@Override
	public void shutdown() {
		// NO-OP
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void unleashEvent(PlayerUnleashEntityEvent event) {
		try {
			Player player = event.getPlayer();
			if (player == null) return;
			UUID uuid = player.getUniqueId();

			Entity entity = event.getEntity();
			
			Chunk chunk = entity.getLocation().getChunk();
			
			DataSample unleash = new PointDataSample("player.unleash." + event.getReason().toString(),
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					entity.getType().toString());
			this.record(unleash);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Unleash Event in CivSpy", e);
		}
	}
}
