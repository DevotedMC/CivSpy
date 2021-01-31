package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.Location;
import org.bukkit.block.Block;
import org.bukkit.block.Hopper;
import org.bukkit.block.Lectern;
import org.bukkit.entity.AbstractArrow;
import org.bukkit.entity.Entity;
import org.bukkit.entity.EntityType;
import org.bukkit.entity.Item;
import org.bukkit.entity.Player;
import org.bukkit.entity.minecart.HopperMinecart;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.entity.EntityPickupItemEvent;
import org.bukkit.event.inventory.InventoryPickupItemEvent;
import org.bukkit.event.player.PlayerPickupArrowEvent;
import org.bukkit.event.player.PlayerTakeLecternBookEvent;
import org.bukkit.inventory.Inventory;
import org.bukkit.inventory.InventoryHolder;
import org.bukkit.inventory.ItemStack;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;
import com.programmerdan.minecraft.civspy.util.ItemStackToString;

/**
 * Contributes <code>player.pickup</code> stats when a person picks up something
 * <br><br>
 * Contributes <code>entity.pickup.TYPE</code> stats when an entity (not a person) picks up something
 * <br><br>
 * Contributes <code>inventory.pickup.TYPE</code> when an inventory holder picks up an item.
 * TYPE is the Hopper or HopperMinecart that picked up the item.
 * <br><br>
 * Contributes <code>lectern.take</code> when a player takes a book from a lectern.
 * The String and value relate to the book taken from the lectern.
 * <br><br>
 * Contributes <code>player.pickup.arrow</code> a special event when a player picks up a previously fired
 * "arrow" which includes tridents.
 * 
 * @author ProgrammerDan
 *
 */
public class PickupListener extends ServerDataListener {

	public PickupListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}

	@Override
	public void shutdown() {
		// no-op
	}

	/**
	 * Please note that this event handler will only work for PAPER. The
	 * Spigot event has an .getItem() deprecated but does not provide a non-deprecated replacement.
	 * Very silly.... Paper does not have this defect.
	 * 
	 * @param event
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void playerPickupArrow(PlayerPickupArrowEvent event) {
		try {
			Player picker = (Player) event.getPlayer();
			if (picker == null) {
				return;
			}
			UUID id = picker.getUniqueId();
			AbstractArrow toPick = event.getArrow();
			if (toPick == null) {
				return;
			}
			
			Location location = toPick.getLocation();
			if (location == null) {
				if (toPick.isInBlock()) {
					Block block = toPick.getAttachedBlock();
					if (block != null) {
						location = block.getLocation();
					} else {
						return;
					}
				} else {
					return;
				}
			}
			Chunk chunk = location.getChunk();
			
			// PAPER ONLY
			ItemStack pick = toPick.getItemStack();
			if (pick == null) {
				return;
			}
			ItemStack pickQ = pick.clone();
			pickQ.setAmount(1);
			DataSample rpick = new PointDataSample("player.pickup.arrow", this.getServer(),
					chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(pickQ), pick.getAmount());
			this.record(rpick);
			
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a player arrow event", e);
		}
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void playerPickupListener(EntityPickupItemEvent event) {
		if (EntityType.PLAYER.equals(event.getEntityType())) {
			try {
				Player picker = (Player) event.getEntity();
				if (picker == null) return;
				UUID id = picker.getUniqueId();
				Item toPick = event.getItem();
				if (toPick == null) return;
				
				Location location = toPick.getLocation();
				if (location == null) return;
				Chunk chunk = location.getChunk();
				
				ItemStack pick = toPick.getItemStack();
				if (pick == null) return;
				ItemStack pickQ = pick.clone();
				pickQ.setAmount(1);
				DataSample rpick = new PointDataSample("player.pickup", this.getServer(),
						chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
						ItemStackToString.toString(pickQ), pick.getAmount());
				this.record(rpick);
			} catch (Exception e) {
				logger.log(Level.WARNING, "Failed to spy a player pickup event", e);
			}
		} else {
			try {
				Entity picker = event.getEntity();
				if (picker == null) return;
				String type = picker.getType().name();
				UUID id = picker.getUniqueId();
				Item toPick = event.getItem();
				if (toPick == null) return;
				
				Location location = toPick.getLocation();
				if (location == null) return;
				Chunk chunk = location.getChunk();
				
				ItemStack pick = toPick.getItemStack();
				if (pick == null) return;
				ItemStack pickQ = pick.clone();
				pickQ.setAmount(1);
				DataSample rpick = new PointDataSample("entity.pickup." + type, this.getServer(),
						chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
						ItemStackToString.toString(pickQ), pick.getAmount());
				this.record(rpick);
			} catch (Exception e) {
				logger.log(Level.WARNING, "Failed to spy an entity pickup event", e);
			}
		}
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void inventoryPickupListener(InventoryPickupItemEvent event) {
		try {
			Inventory inventory = event.getInventory();
			if (inventory == null) return;
			Location location = inventory.getLocation();
			Chunk chunk = location.getChunk();
			
			InventoryHolder holder = inventory.getHolder();
			if (holder == null) return;
			String picker = null;
			
			if (holder instanceof Hopper) {
				picker = "Hopper";
			} else if (holder instanceof HopperMinecart) {
				picker = "HopperMinecart";
			} else {
				picker = "Unknown";
			}
			
			Item item = event.getItem();
			ItemStack pick = item.getItemStack();
			ItemStack pickQ = pick.clone();
			pickQ.setAmount(1);
			DataSample rpick = new PointDataSample("inventory.pickup." + picker, this.getServer(),
					chunk.getWorld().getName(), null, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(pickQ), pick.getAmount());
			this.record(rpick);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an inventory pickup event", e);
		}
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void takeLecternEvent(PlayerTakeLecternBookEvent event) {
		try {
			Lectern lectern = event.getLectern();
			
			ItemStack book = event.getBook();
			if (book == null) {
				return; // event considers it nullable
			}
			
			Location location = lectern.getLocation();
			Chunk chunk = location.getChunk();
			
			ItemStack clone = book.clone();
			clone.setAmount(1);
			
			DataSample lect = new PointDataSample("lectern.take", this.getServer(),
					chunk.getWorld().getName(), null, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(clone), book.getAmount());
			this.record(lect);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a lectern event", e);
		}
	}
}
