package com.programmerdan.minecraft.civspy.listeners.impl;

import java.util.logging.Level;
import java.util.logging.Logger;

import org.bukkit.Chunk;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;

import com.devotedmc.ExilePearl.ExilePearl;
import com.devotedmc.ExilePearl.event.PearlMovedEvent;
import com.devotedmc.ExilePearl.event.PearlReturnEvent;
import com.devotedmc.ExilePearl.event.PearlSummonEvent;
import com.devotedmc.ExilePearl.event.PlayerFreedEvent;
import com.devotedmc.ExilePearl.event.PlayerPearledEvent;
import com.programmerdan.minecraft.civspy.DataManager;
import com.programmerdan.minecraft.civspy.DataSample;
import com.programmerdan.minecraft.civspy.PointDataSample;
import com.programmerdan.minecraft.civspy.listeners.ServerDataListener;

/**
 * Contributes <code>exilepearl.EVENT</code> stats when an exilepearl event is triggered.
 * EVENT is the type of event.
 * For <code>pearl</code> event, means a player was pearled. The player data field is the player pearled, the String field is the
 * player doing the pearling.
 * For <code>moveto</code> event, means the pearl was moved to a new contained. String field is the name of the container.
 * For <code>freed</code> event, means the pearl was freed. String field is the reason for freeing.
 * For <code>summon</code> event, means the player was summoned from the pearl (PrisonPearl functionality). 
 * String field is the player doing the summoning.
 * For <code>return</code> event, means the player was sent back to the pearl (PrisonPearl functionality).
 * String field is the name of the world the player is being sent back to.
 * 
 * @author ProgrammerDan
 *
 */
public class ExilePearlListener extends ServerDataListener {

	public ExilePearlListener(DataManager target, Logger logger, String server) {
		super(target, logger, server);
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void onPlayerPearledEvent(PlayerPearledEvent event) {
		try {
			ExilePearl pearl = event.getPearl();
			
			Chunk chunk = pearl.getLocation() != null ? pearl.getLocation().getChunk() : null;
						
			DataSample rslay = new PointDataSample("exilepearl.pearl", this.getServer(),
					chunk != null ? chunk.getWorld().getName() : null, pearl.getPlayerId(), 
					chunk != null ? chunk.getX() : null,  chunk != null ? chunk.getZ() : null, 
					pearl.getKillerId() != null ? pearl.getKillerId().toString() : pearl.getKillerName());
			this.record(rslay);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an exilepearl pearl event", e);
		}
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void onPearlMovedEvent(PearlMovedEvent event) {
		try {
			ExilePearl pearl = event.getPearl();
			
			Chunk chunk = pearl.getLocation() != null ? pearl.getLocation().getChunk() : 
					event.getDestinationHolder().getLocation() != null ? event.getDestinationHolder().getLocation().getChunk()
					: null;
						
			DataSample rmove = new PointDataSample("exilepearl.moveto", this.getServer(),
					chunk != null ? chunk.getWorld().getName() : null, pearl.getPlayerId(), 
					chunk != null ? chunk.getX() : null,  chunk != null ? chunk.getZ() : null, 
					event.getDestinationHolder().getName());
			this.record(rmove);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an exilepearl move event", e);
		}
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void onPearlSummonEvent(PearlSummonEvent event) {
		try {
			Player summoner = event.getSummoner();
			ExilePearl pearl = event.getPearl();
			
			Chunk chunk = pearl.getLocation() != null ? pearl.getLocation().getChunk() : 
					null;
			if (chunk == null) { // if we don't have a pearl location, use the summoner's location. Closest proxy.
				chunk = summoner.getChunk();
			}
			
			DataSample rmove = new PointDataSample("exilepearl.summoned", this.getServer(),
					chunk != null ? chunk.getWorld().getName() : null, pearl.getPlayerId(), 
					chunk != null ? chunk.getX() : null,  chunk != null ? chunk.getZ() : null, 
					summoner.getUniqueId().toString());
			this.record(rmove);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an exilepearl summon event", e);
		}
	}

	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void onPearlReturnEvent(PearlReturnEvent event) {
		try {
			ExilePearl pearl = event.getPearl();
			
			Chunk chunk = pearl.getLocation() != null ? pearl.getLocation().getChunk() : 
					null;
			
			DataSample rmove = new PointDataSample("exilepearl.return", this.getServer(),
					chunk != null ? chunk.getWorld().getName() : null, pearl.getPlayerId(), 
					chunk != null ? chunk.getX() : null,  chunk != null ? chunk.getZ() : null, 
					event.getPearl().getReturnLocation().getWorld().getName());
			this.record(rmove);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an exilepearl summon event", e);
		}
	}
	
	@EventHandler(priority=EventPriority.MONITOR, ignoreCancelled=true)
	public void onPlayerFreedEvent(PlayerFreedEvent event) {
		try {
			ExilePearl pearl = event.getPearl();
			
			Chunk chunk = pearl.getLocation() != null ? pearl.getLocation().getChunk() : null;
						
			DataSample rfree = new PointDataSample("exilepearl.freed", this.getServer(),
					chunk != null ? chunk.getWorld().getName() : null, pearl.getPlayerId(), 
					chunk != null ? chunk.getX() : null,  chunk != null ? chunk.getZ() : null, 
					event.getReason().toString());
			this.record(rfree);
		} catch (Exception e) {
			logger.log(Level.WARNING, "Failed to spy an exilepearl free event", e);
		}
	}
	
	@Override
	public void shutdown() {
		// NO-OP
	}

}
