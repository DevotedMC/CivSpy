package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Art;
import org.bukkit.Chunk;
import org.bukkit.entity.Entity;
import org.bukkit.entity.Hanging;
import org.bukkit.entity.HumanEntity;
import org.bukkit.entity.ItemFrame;
import org.bukkit.entity.LeashHitch;
import org.bukkit.entity.Painting;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.hanging.HangingBreakByEntityEvent;
import org.bukkit.event.hanging.HangingBreakEvent;
import org.bukkit.event.hanging.HangingPlaceEvent;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;
import com.programmerdan.minecraft.civspy.util.ItemStackToString;

/**
 * Contributes <code>hanging.place.by.TYPE</code> and <code>hanging.break.CAUSE.TYPE</code> 
 * If placed or broken by a player, includes their UUID. String value for both is details on the Hanging. 
 * Type is the entitytype that broke/placed it, as close as can be determined.
 * @author ProgrammerDan
 *
 */
public class HangingListener extends ServerDataListener {

	public HangingListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}

	@Override
	public void shutdown() {
		// NO-OP
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void placeEvent(HangingPlaceEvent event) {
		try {
			Player player = event.getPlayer();
			UUID uuid = player != null ? player.getUniqueId() : null;
			String type = player != null ? "PLAYER" : "UNKNOWN";
			Hanging hanging = event.getEntity();
			
			Chunk chunk = hanging.getLocation().getChunk();
			
			StringBuilder sb = new StringBuilder(hanging.getType().toString());
			sb.append('_').append(hanging.getFacing().toString());
			if (hanging instanceof ItemFrame) {
				ItemFrame frame = (ItemFrame) hanging;
				sb.append('/').append(frame.getRotation().toString())
						.append('[').append(ItemStackToString.toString(frame.getItem()))
						.append(']');
			} else if (hanging instanceof LeashHitch) {
				//no-op as of 1.16.4
			} else if (hanging instanceof Painting) {
				Painting paint = (Painting) hanging;
				Art art = paint.getArt();
				sb.append('/').append(art.toString());
			}
			DataSample place = new PointDataSample("hanging.place.by." + type,
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					sb.toString());
			this.record(place);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Hanging Place Event in CivSpy", e);
		}
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void breakEvent(HangingBreakEvent event) {
		try {
			if (event instanceof HangingBreakByEntityEvent) {
				return;
			}
			Hanging hanging = event.getEntity();
			
			Chunk chunk = hanging.getLocation().getChunk();
			
			StringBuilder sb = new StringBuilder(hanging.getType().toString());
			sb.append('_').append(hanging.getFacing().toString());
			if (hanging instanceof ItemFrame) {
				ItemFrame frame = (ItemFrame) hanging;
				sb.append('/').append(frame.getRotation().toString())
						.append('[').append(ItemStackToString.toString(frame.getItem()))
						.append(']');
			} else if (hanging instanceof LeashHitch) {
				//no-op as of 1.16.4
			} else if (hanging instanceof Painting) {
				Painting paint = (Painting) hanging;
				Art art = paint.getArt();
				sb.append('/').append(art.toString());
			}
			DataSample hbreak = new PointDataSample("hanging.break.by." + event.getCause().toString() + ".UNKNOWN",
					this.getServer(), chunk.getWorld().getName(), null, chunk.getX(), chunk.getZ(), 
					sb.toString());
			this.record(hbreak);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Hanging Break Event in CivSpy", e);
		}
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void entityBreakEvent(HangingBreakByEntityEvent event) {
		try {
			Entity remover = event.getRemover();
			UUID uuid = remover instanceof HumanEntity ? ((HumanEntity) remover).getUniqueId() : null;
			String type = remover.getType().toString();
			
			Hanging hanging = event.getEntity();
			
			Chunk chunk = hanging.getLocation().getChunk();
			
			StringBuilder sb = new StringBuilder(hanging.getType().toString());
			sb.append('_').append(hanging.getFacing().toString());
			if (hanging instanceof ItemFrame) {
				ItemFrame frame = (ItemFrame) hanging;
				sb.append('/').append(frame.getRotation().toString())
						.append('[').append(ItemStackToString.toString(frame.getItem()))
						.append(']');
			} else if (hanging instanceof LeashHitch) {
				//no-op as of 1.16.4
			} else if (hanging instanceof Painting) {
				Painting paint = (Painting) hanging;
				Art art = paint.getArt();
				sb.append('/').append(art.toString());
			}
			DataSample hbreak = new PointDataSample("hanging.break.by." + event.getCause().toString() + '.' + type,
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					sb.toString());
			this.record(hbreak);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Hanging Break by entity Event in CivSpy", e);
		}
	}
}
