package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.Location;
import org.bukkit.block.Block;
import org.bukkit.entity.Entity;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.block.BlockShearEntityEvent;
import org.bukkit.event.player.PlayerBedEnterEvent;
import org.bukkit.event.player.PlayerBedLeaveEvent;
import org.bukkit.event.player.PlayerShearEntityEvent;
import org.bukkit.inventory.ItemStack;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;
import com.programmerdan.minecraft.civspy.util.ItemStackToString;

/**
 * Covers shearing.
 * 
 * @author ProgrammerDan
 *
 */
public class ShearListener extends ServerDataListener {

	public ShearListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}

	@Override
	public void shutdown() {
		// NO-OP
	}

	/**
	 * Generates <code>player.shear</code> where String Value is the EntityType of the entity being sheared.
	 * 
	 * @param event the shear event.
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void shearEvent(PlayerShearEntityEvent event) {
		try {
			Player player = event.getPlayer();
			if (player == null) {
				return;
			}
			UUID id = player.getUniqueId();
			
			Entity sheared = event.getEntity();
			
			Chunk chunk = sheared.getChunk();
			
			DataSample shearGen = new PointDataSample("player.shear", this.getServer(),
					chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
					sheared.getType().toString());
			this.record(shearGen);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a shear event", e);
		}
	}
	
	/**
	 * Generates <code>block.shear.TYPE</code> where TYPE is the EntityType of the entity being sheared, and
	 * String data is the blockstate/type of the block that did the shearing.
	 * 
	 * @param event the block shear event
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void blockShearEvent(BlockShearEntityEvent event) {
		try {
			Block block = event.getBlock();
			
			Entity sheared = event.getEntity();
			
			Chunk chunk = sheared.getChunk();
			
			DataSample shearGen = new PointDataSample("block.shear." + sheared.getType(), this.getServer(),
					chunk.getWorld().getName(), null, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(block.getState()));
			this.record(shearGen);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a block shear event", e);
		}
	}
}
