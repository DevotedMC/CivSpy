package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.Location;
import org.bukkit.block.Block;
import org.bukkit.entity.Entity;
import org.bukkit.entity.HumanEntity;
import org.bukkit.entity.LivingEntity;
import org.bukkit.entity.Player;
import org.bukkit.entity.Projectile;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.entity.EntityDamageByBlockEvent;
import org.bukkit.event.entity.EntityDamageByEntityEvent;
import org.bukkit.event.entity.EntityDamageEvent;
import org.bukkit.event.entity.EntityDeathEvent;
import org.bukkit.event.entity.PlayerDeathEvent;
import org.bukkit.inventory.ItemStack;
import org.bukkit.projectiles.ProjectileSource;

import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;
import com.programmerdan.minecraft.civspy.util.ItemStackToString;

/**
 * Listener that accumulates kills of non-players by players, and players by entities (including players).
 * <br>
 * Contributes <code>entity.death.TYPE</code> and <code>entity.death.drop.TYPE</code> and <code>entity.death.xp.TYPE</code>
 * where TYPE is the EntityType.name() of what died, and <code>entity.death.by.TYPE</code> which shows the tool that killed the entity,
 * and <code>entity.death.killer.TYPE</code> if the killer isn't a player, showing what did kill it (UUID will be empty).
 * <br>
 * If killer is a player and isn't empty, UUID is filled for all. Otherwise is null.
 * <br>
 * If creature has a custom name, recorded in string value field for death and XP; not for drop (itemstack serialization recorded there).
 * <br>
 * Contributes <code>player.killed</code> and <code>player.died</code> and <code>player.killed.drop</code> and <code>player.died.drop</code>
 * <code>.killed</code> is used for PVP kills or death by entities, the UUID of the player or TYPE/Name of the entity responsible for killing is in hte
 * string value field. The UUID field holds the player killed in all cases. If <code>.died</code> then killed by 
 * some non-strictly-entity cause (drowning, etc.).
 * The <code>.drop</code> contributions are similar to entity death, but the UUID recorded is the player that died.
 * Also contributes <code>player.killed.by</code> to show what weapon killed them, if any.
 * @author ProgrammerDan
 */
public final class HuntingListener extends ServerDataListener {

	public HuntingListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}
	
	@Override
	public void shutdown() {
		// NO-OP
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void capturePlayerDeath(PlayerDeathEvent event) {
		try {
			Player died = event.getEntity();
			if (died == null) return;
			
			UUID playerUUID = died.getUniqueId();
			
			Location location = died.getLocation();
			Chunk chunk = location.getChunk();
			
			String killerName = null;
			String killerTool = null;
			boolean killerIsEntity = false;
			if (died.getKiller() != null) {
				Player killer = died.getKiller();
				killerTool = ItemStackToString.toString(killer.getEquipment().getItemInMainHand());
				killerName = killer.getUniqueId().toString();
				killerIsEntity = true;
			} else if (died.getLastDamageCause() != null) {
				EntityDamageEvent ede = died.getLastDamageCause();
				if (ede instanceof EntityDamageByEntityEvent) {
					killerIsEntity = true;
					Entity killer = ((EntityDamageByEntityEvent) ede).getDamager();
					if (killer != null) {
						if (killer instanceof Projectile) {
							// Projectiles do the killing, but they are launched by someone!
							Projectile arrow = (Projectile) killer;
							ProjectileSource ps = arrow.getShooter();
							if (ps instanceof Entity) {
									Entity psk = (Entity) ps;
									killerName = psk.getCustomName() != null ? psk.getCustomName() : psk.getType().toString();
							} else {
									killerName = "ProjectileLauncher-" + killer.getType().toString(); 
							}
							// record the tool as the arrow that hit.
							killerTool = arrow.getType().toString();
						} else if (killer instanceof LivingEntity) {
							if (((LivingEntity) killer).getEquipment() != null) {
								killerTool = ItemStackToString.toString(((LivingEntity) killer).getEquipment().getItemInMainHand());
							}
						}
						if (killerName == null) {
							killerName = killer.getCustomName() != null ? killer.getCustomName() : killer.getType().toString();
						}
					} else {
						killerName = "Unknown";
					}
				} else if (ede instanceof EntityDamageByBlockEvent) {
					EntityDamageByBlockEvent edbe = (EntityDamageByBlockEvent) ede;
					Block block = edbe.getDamager();
					if (block != null) {
						killerName = ItemStackToString.toString(block.getState());
					} else {
						killerName = "Block";
					}
				} else {
					killerName = ede.getCause().toString();
				}
			} else {
				killerIsEntity = event.getEntityType() != null;
				killerName = (killerIsEntity ? event.getEntityType().toString() : "Unknown");
			}
			
			DataSample death = new PointDataSample("player." + (killerIsEntity ? "killed" : "died"), this.getServer(),
						chunk.getWorld().getName(), playerUUID, chunk.getX(), chunk.getZ(), 
						killerName);
			this.record(death);

			if (killerTool != null) {
				DataSample by = new PointDataSample("player." + (killerIsEntity ? "killed.by" : "died.by"), this.getServer(),
						chunk.getWorld().getName(), playerUUID, chunk.getX(), chunk.getZ(), 
						killerTool);
				this.record(by);
			}
			
			List<ItemStack> dropped = event.getDrops();
			
			if (dropped != null && dropped.size() > 0) {
				for (ItemStack drop : dropped) {
					if (drop == null) continue;
					ItemStack dropQ = drop.clone();
					dropQ.setAmount(1);
					DataSample deathdrop = new PointDataSample("player." + (killerIsEntity ? "killed.drop" : "died.drop"),
							this.getServer(), chunk.getWorld().getName(), playerUUID, chunk.getX(), chunk.getZ(), 
							ItemStackToString.toString(dropQ), drop.getAmount());
					this.record(deathdrop);
				}
			}
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy a player death event", e);
		}
	}
	
	// Added the tool used and discovery of killer on EntityDeath Event. So will record entity v entity death.
	// New TODO: need to add ways to shut off stuff folks don't want to catch.
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void captureDeath(EntityDeathEvent event) {
		try {
			if (event instanceof PlayerDeathEvent || event.getEntity() == null || event.getEntity() instanceof Player) return;
	
			LivingEntity died = event.getEntity();
			List<ItemStack> dropped = event.getDrops();
			int xpd = event.getDroppedExp();
	
			Player killer = died.getKiller();
			UUID killerUUID = killer == null ? null : killer.getUniqueId();
			String killerName = null;
			String killerTool = null;
	
			Location location = died.getLocation();
			Chunk chunk = location.getChunk();
	
			String type = died.getType().name();
			String diedCName = died.getCustomName();
			
			if (killer != null) {
				killerTool = ItemStackToString.toString(killer.getEquipment().getItemInMainHand());
			} else {
				EntityDamageEvent lastDamage = died.getLastDamageCause();
				if (lastDamage instanceof EntityDamageByEntityEvent) {
					Entity killerEntity = ((EntityDamageByEntityEvent) lastDamage).getDamager();
					if (killerEntity != null) {
						if (killerEntity instanceof Projectile) {
							// Projectiles do the killing, but they are launched by someone!
							Projectile arrow = (Projectile) killerEntity;
							ProjectileSource ps = arrow.getShooter();
							if (ps instanceof Entity) {
								Entity psk = (Entity) ps;
								killerName = psk.getCustomName() != null ? psk.getCustomName() : psk.getType().toString();
								
								if (psk instanceof HumanEntity) {
									killerUUID = psk.getUniqueId();
								}
							} else {
								killerName = "ProjectileLauncher-" + killerEntity.getType().toString(); 
							}
							// record the tool as the arrow that hit.
							killerTool = arrow.getType().toString();
						} else if (killerEntity instanceof LivingEntity) {
							if (((LivingEntity) killerEntity).getEquipment() != null) {
								killerTool = ItemStackToString.toString(((LivingEntity) killerEntity).getEquipment().getItemInMainHand());
							}
							
							if (killerEntity instanceof HumanEntity) {
								killerUUID = killerEntity.getUniqueId();
							}
						}
						if (killerName == null) {
							killerName = killerEntity.getCustomName() != null ? killerEntity.getCustomName() : killerEntity.getType().toString();
						}
					} else {
						killerName = "Unknown";
					}
				} else if (lastDamage instanceof EntityDamageByBlockEvent) {
					EntityDamageByBlockEvent edbe = (EntityDamageByBlockEvent) lastDamage;
					Block block = edbe.getDamager();
					if (block != null) {
						killerName = ItemStackToString.toString(block.getState());
					} else {
						killerName = "Block:" + edbe.getCause().toString();
					}
				} else {
					killerName = lastDamage.getCause().toString();
				}
			}

			
			if (killerName != null) {
				DataSample killerSample = new PointDataSample("entity.death.killer." + type, this.getServer(),
						chunk.getWorld().getName(), killerUUID, chunk.getX(), chunk.getZ(), killerName);
				this.record(killerSample);
			}
			
			if (killerTool != null) {
				DataSample killerSample = new PointDataSample("entity.death.by." + type, this.getServer(),
						chunk.getWorld().getName(), killerUUID, chunk.getX(), chunk.getZ(), killerTool);
				this.record(killerSample);
			}
			
			DataSample death = new PointDataSample("entity.death." + type, this.getServer(),
					chunk.getWorld().getName(), killerUUID, chunk.getX(), chunk.getZ(), diedCName);
			this.record(death);
	
			if (dropped != null && dropped.size() > 0) {
				for (ItemStack drop : dropped) {
					if (drop == null) continue;
					ItemStack dropQ = drop.clone();
					dropQ.setAmount(1);
					DataSample deathdrop = new PointDataSample("entity.death.drop." + type, this.getServer(),
							chunk.getWorld().getName(), killerUUID, chunk.getX(), chunk.getZ(), 
							ItemStackToString.toString(dropQ), drop.getAmount());
					this.record(deathdrop);
				}
			}
	
			if (xpd > 0) {
				DataSample deathxp = new PointDataSample("entity.death.xp." + type, this.getServer(),
						chunk.getWorld().getName(), killerUUID, chunk.getX(), chunk.getZ(), diedCName, xpd);
				this.record(deathxp);
			}
			
			
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an entity death event", e);
		}
	}
}
