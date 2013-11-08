# Geoloader

Geoloader is a simple little gem that automates the process of loading [GeoTIFFs][geotiff] and [Shapfiles][shapefile] into [Geoserver][geoserver], and [Solr][solr], the services that power the geospatial search interface at the University of Virginia Library.

## Quick Examples

```bash
# Load an individual GeoTIFF to Geoserver and Solr:
geoloader load /path/to/geotiff.tif

# Load an individual Shapefile to Geoserver and Solr:
geoloader load /path/to/shapefile.shp

# Load all files matched by wildcard:
geoloader load /path/to/files/*

# Just load files to Geoserver.
geoloader load /path/to/files/* --services geoserver

# Just load files to Solr.
geoloader load /path/to/files/* --services solr

# Load files to a custom workspace.
geoloader load /path/to/files/* --workspace aerials

# Merge YAML-defined metadata into the Solr documents.
geoloader load /path/to/files/* --metadata /path/to/yaml

# Push the uploads onto a Resque queue.
geoloader load /path/to/files/* --queue

# Start a Resque worker.
geoloader work
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[geoserver]: http://geoserver.org/
[solr]: http://lucene.apache.org/solr/
[jeweler]: https://github.com/technicalpickles/jeweler
