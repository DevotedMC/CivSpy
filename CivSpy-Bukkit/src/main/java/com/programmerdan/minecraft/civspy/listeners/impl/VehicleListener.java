package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.entity.Entity;
import org.bukkit.entity.HumanEntity;
import org.bukkit.entity.LivingEntity;
import org.bukkit.entity.Vehicle;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.vehicle.VehicleDestroyEvent;
import org.bukkit.event.vehicle.VehicleEnterEvent;
import org.bukkit.event.vehicle.VehicleExitEvent;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;

/**
 * <code>vehicle.enter.TYPE</code> and <code>vehicle.exit.TYPE</code> and <code>vehicle.destroy.TYPE</code>.
 * 
 * includes player/entity (ID if player, String is type of entity) and nature of vehicle (TYPE is vehicle type).
 * 
 * @author ProgrammerDan
 *
 */
public class VehicleListener extends ServerDataListener {

	public VehicleListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}

	@Override
	public void shutdown() {
		// NO-OP
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void enterEvent(VehicleEnterEvent enterEvent) {
		try {
			Entity entity = enterEvent.getEntered();
			String entityType = entity.getType().toString();
			Vehicle vehicle = enterEvent.getVehicle();
			String vehicleType = vehicle.getType().toString();
			
			UUID uuid = null;
			if (entity instanceof HumanEntity) {
				HumanEntity player = (HumanEntity) entity;
				uuid = player.getUniqueId();
			}
			Chunk chunk = vehicle.getLocation().getChunk();
			
			DataSample enter = new PointDataSample("vehicle.enter." + vehicleType,
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					entityType);
			this.record(enter);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Vehicle Enter Event in CivSpy", e);
		}
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void leaveEvent(VehicleExitEvent leaveEvent) {
		try {
			LivingEntity entity = leaveEvent.getExited();
			String entityType = entity.getType().toString();
			Vehicle vehicle = leaveEvent.getVehicle();
			String vehicleType = vehicle.getType().toString();
			
			UUID uuid = null;
			if (entity instanceof HumanEntity) {
				HumanEntity player = (HumanEntity) entity;
				uuid = player.getUniqueId();
			}
			Chunk chunk = vehicle.getLocation().getChunk();
			
			DataSample enter = new PointDataSample("vehicle.exit." + vehicleType,
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					entityType);
			this.record(enter);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Vehicle Exit Event in CivSpy", e);
		}
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void destroyEvent(VehicleDestroyEvent destroyEvent) {
		try {
			Entity entity = destroyEvent.getAttacker();
			String entityType = entity.getType().toString();
			Vehicle vehicle = destroyEvent.getVehicle();
			String vehicleType = vehicle.getType().toString();
			
			UUID uuid = null;
			if (entity instanceof HumanEntity) {
				HumanEntity player = (HumanEntity) entity;
				uuid = player.getUniqueId();
			}
			Chunk chunk = vehicle.getLocation().getChunk();
			
			DataSample enter = new PointDataSample("vehicle.destroy." + vehicleType,
					this.getServer(), chunk.getWorld().getName(), uuid, chunk.getX(), chunk.getZ(), 
					entityType);
			this.record(enter);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Failed to track Vehicle Destroy Event in CivSpy", e);
		}
	}
}
