# Geoloader

Geoloader is a simple little gem that automates the process of loading [GeoTIFFs][geotiff] and [Shapfiles][shapefile] into [Geoserver][geoserver], and [Solr][solr], the services that power the geospatial search interface at the University of Virginia Library.

## Quick Examples

```bash
geoloader load /path/to/geotiff.tif
geoloader load /path/to/shapefile.shp
geoloader load /path/to/files/*
geoloader load /path/to/files/* --services geoserver
geoloader load /path/to/files/* --services solr
geoloader load /path/to/files/* --workspace aerials
geoloader load /path/to/files/* --metadata /path/to/yaml
geoloader load /path/to/files/* --queue
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[geoserver]: http://geoserver.org/
[solr]: http://lucene.apache.org/solr/
[jeweler]: https://github.com/technicalpickles/jeweler
