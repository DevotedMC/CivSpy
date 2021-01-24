I've been working with CivSpy for a long time now, and I have collected a number of queries that I use to regularly keep track on performance and activity on my server, that might be useful to you, since the CivSpy-UI has made no progress.

# Queries make raw data better

CivSpy focuses on aggregate data, but this data is remarkably useful for just about any question you have. For instance, we've used it to identify alt-ban evaders equipping their alts, monitor dupe use, track plugin failures and more easily refund inventories in cases of glitching, validate economic indicators, identify high-activity regions, and more.

What will follow in these query files are examples of long term tracking data that can be produced. Consider these as templates, and alter to include the data you are interested in tracking or publishing. 

Easily make "high-score" billboards / tracking for your players, etc.


## CivSpy Grafana series

This is a series of JSON files that should be importable into Grafana. You will need to tweak the database before you import, and note by default all references to `server` in the queries points to `devoted`, so you should update that to match your own server.


## CivSpy SQL series

These are complex queries illustrating deep analysis that is possible with large or small histories from CivSpy. Note that these queries don't touch all the data collected by CivSpy, which has been expanded recently.

I've ordered them using 1_ 2_ 3_ etc. -- in some cases they need to be run in that order, as 2_ depends on subtables and views created in 1_, etc. 

I'd recommend studying these query files. They were designed for devoted, so `server='devoted'` is everywhere -- you will need to alter that in your own use, especially if you are aggregating from multiple servers.

The depth of analysis that is possible is incredible. You'll see hinted at, but when running Devoted I made weekly extracts of the data (Saturday morning, every week) and those extracts where exported into an analysis server.
On that analysis server, I ran the queries (and more) listed in these `.sql` files. This gave me deep insights into what everyone was doing everywhere, identify quickly bad or aberrant behavior.

# Conclusion

Hopefully these example queries inspire you, but regardless:

Most of all, have fun with it!

