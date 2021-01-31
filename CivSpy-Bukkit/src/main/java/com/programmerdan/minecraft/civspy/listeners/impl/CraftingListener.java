package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.Location;
import org.bukkit.entity.HumanEntity;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.inventory.CraftItemEvent;
import org.bukkit.event.player.PlayerEditBookEvent;
import org.bukkit.event.player.PlayerItemMendEvent;
import org.bukkit.inventory.CraftingInventory;
import org.bukkit.inventory.ItemStack;
import org.bukkit.inventory.meta.BookMeta;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;
import com.programmerdan.minecraft.civspy.util.ItemStackToString;

/**
 * Listener that records crafting recipe use, 
 * mending use, book editing.
 * 
 * @author ProgrammerDan
 */
public final class CraftingListener extends ServerDataListener {

	public CraftingListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}
	
	@Override
	public void shutdown() {
		// NO-OP
	}
	
	/**
	 * Generates: <code>player.craft</code> stat_key data.
	 * ItemStack size stored in number value, serialized string in string value.
	 * 
	 * @param event Craft event
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void craftListen(CraftItemEvent event) {
		try {
			HumanEntity player = event.getWhoClicked();
			if (player == null) {
				return;
			}
			UUID id = player.getUniqueId();
		
			Location location = player.getLocation();
			Chunk chunk = location.getChunk();
			
			CraftingInventory resultMap = event.getInventory();
			if (resultMap == null) {
				return;
			}
			ItemStack result = resultMap.getResult();
			if (result == null) {
				if (event.getRecipe() != null) {
					logger.log(Level.INFO, "Result was null on a crafting event - {0}", 
							event.getRecipe().getResult());
				} else {
					logger.log(Level.INFO, "Result was null on a crafting event  ??");
				}
				return;
			}
			
			ItemStack stack = result.clone();
			stack.setAmount(1);
			
			DataSample recipeGen = new PointDataSample("player.craft", this.getServer(),
					chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(stack), result.getAmount());
			this.record(recipeGen);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a craft event", e);
		}
	}

	/**
	 * Generates: <code>player.mend</code> stat_key data.
	 * ItemStack size stored in number value, serialized string in string value.
	 * 
	 * At present not recording how much was mended.
	 * 
	 * @param event the Mend event
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void mendListen(PlayerItemMendEvent event) {
		try {
			HumanEntity player = event.getPlayer();
			if (player == null) {
				return;
			}
			UUID id = player.getUniqueId();
			
			Location location = player.getLocation();
			Chunk chunk = location.getChunk();
			
			ItemStack result = event.getItem();
			if (result == null) {
				logger.log(Level.INFO, "Result was null on a ment event ??");
				return;
			}
			
			ItemStack stack = result.clone();
			stack.setAmount(1);
			
			DataSample mendGen = new PointDataSample("player.mend", this.getServer(),
					chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(stack), result.getAmount());
			this.record(mendGen);
			
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a mend event", e);
		}
	}
	
	/**
	 * Generates: <code>player.book.edit.SIGN</code> where SIGN is true or false depending on
	 * if the book is being signed. String value is title / pages / headmatter / generations for 
	 * the book, not the book contents.
	 * 
	 * @param event the edit event
	 */
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void editBook(PlayerEditBookEvent event) {
		try {
			Player player = event.getPlayer();
			if (player == null) {
				return;
			}
			BookMeta newMeta = event.getNewBookMeta();
			if (newMeta == null) {
				return;
			}
			String signState = event.isSigning() ? "true" : "false";
			
			UUID id = player.getUniqueId();
			
			Location location = player.getLocation();
			Chunk chunk = location.getChunk();
			
			DataSample editGen = new PointDataSample("player.book.edit." + signState, this.getServer(),
					chunk.getWorld().getName(), id, chunk.getX(), chunk.getZ(), 
					ItemStackToString.toString(newMeta));
			this.record(editGen);
			
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an edit event", e);
		}
	}
}