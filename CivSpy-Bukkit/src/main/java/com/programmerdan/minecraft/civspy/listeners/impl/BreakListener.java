package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.block.Block;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.block.BlockBreakEvent;
import org.bukkit.event.player.PlayerHarvestBlockEvent;
import org.bukkit.event.player.PlayerItemBreakEvent;
import org.bukkit.inventory.Inventory;
import org.bukkit.inventory.InventoryHolder;
import org.bukkit.inventory.ItemStack;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;
import com.programmerdan.minecraft.civspy.util.ItemStackToString;

/**
 * Sample Listener class that records all block breaks for summation by who and what.
 * This only records _player_ breaks, so if other entities cause a break those events are
 * ignored.
 * 
 * For 1.16, record harvest events too, and tool break events.
 * 
 * @author ProgrammerDan
 */
public final class BreakListener extends ServerDataListener {

	public BreakListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}
	
	@Override
	public void shutdown() {
		// NO-OP
	}
	
	/**
	 * Generates: <code>player.blockbreak</code> stat_key data. Block encoded attributes
	 * is stored in the string value field.
	 * <br><br>
	 * Generates: <code>block.drop.TYPE</code> when the block broken drops items. 
	 * TYPE is the material type of the block that is dropping stuff.
	 * 
	 * @param event The BlockBreakEvent
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void breakListen(BlockBreakEvent event) {
		try {
			Player p = event.getPlayer();
			if (p == null) return;
			UUID id = p.getUniqueId();
			Block broken = event.getBlock();
			Chunk chunk = broken.getChunk();
			
			if (broken instanceof InventoryHolder) {
				Inventory inventory = ((InventoryHolder) broken).getInventory();
				ItemStack[] dropped = inventory.getStorageContents();
				
				if (dropped != null && dropped.length > 0) {
					for (ItemStack drop : dropped) {
						if (drop == null) continue;
						ItemStack dropQ = drop.clone();
						dropQ.setAmount(1);
						DataSample deathdrop = new PointDataSample("block.drop." + broken.getType().toString(),
								this.getServer(), chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
								ItemStackToString.toString(dropQ), drop.getAmount());
						this.record(deathdrop);
					}
				}
			}
			
			DataSample blockBreak = new PointDataSample("player.blockbreak", this.getServer(),
					chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(broken.getState()));
			this.record(blockBreak);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a break event", e);
		}
	}
	
	/**
	 * Generates: <code>player.blockharvest</code> stat_key data. Block encoded attributes
	 * is stored in the string value field.
	 * <br><br>
	 * Generates: <code>block.harvest.TYPE</code> when the block harvest drops items. 
	 * TYPE is the material type of the block that is dropping stuff.
	 * 
	 * @param event The PlayerHarvestBlockEvent
	 */

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void harvestListen(PlayerHarvestBlockEvent event) {
		try {
			Player p = event.getPlayer();
			if (p == null) return;
			UUID id = p.getUniqueId();
			Block harvested = event.getHarvestedBlock();
			Chunk chunk = harvested.getChunk();
			
			DataSample harvest = new PointDataSample("player.blockharvest", this.getServer(),
					chunk.getWorld().getName(), null, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(harvested.getState()));	
			this.record(harvest);
			
			List<ItemStack> harvestDropped = event.getItemsHarvested();
			
			if (harvestDropped != null && harvestDropped.size() > 0) {
				for (ItemStack drop : harvestDropped) {
					if (drop == null) continue;
					ItemStack dropQ = drop.clone();
					dropQ.setAmount(1);
					DataSample harvestdrop = new PointDataSample("block.harvest." + harvested.getType().toString(),
							this.getServer(), chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
							ItemStackToString.toString(dropQ), drop.getAmount());
					this.record(harvestdrop);
				}
			}
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a harvest event", e);
		}
	}

	/**
	 * Generates a <code>player.item.break</code> when a player's in-use item breaks.
	 * The String / Number values will represent the item that was broken.
	 * 
	 * @param event the break event.
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void toolBreakListen(PlayerItemBreakEvent event) {
		try {
			Player p = event.getPlayer();
			if (p == null) {
				return;
			}
			UUID id = p.getUniqueId();
			Chunk chunk = p.getChunk();
			
			ItemStack broke = event.getBrokenItem();
			if (broke == null) {
				return;
			}
			ItemStack brokeQ = broke.clone();
			brokeQ.setAmount(1);
			
			DataSample breakDS = new PointDataSample("player.item.break",
					this.getServer(), chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(brokeQ), broke.getAmount());
			this.record(breakDS);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a tool break event", e);
		}
	}
	
}
