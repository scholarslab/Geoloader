# Geoloader

Geoloader is a simple little gem that automates the process of loading [GeoTIFFs][geotiff] and [Shapfiles][shapefile] into [Geoserver][geoserver], and [Solr][solr], the services that power the geospatial search interface at the University of Virginia Library.

## Quick Examples

From the command line:

```bash
# Load an individual GeoTIFF to Geoserver and Solr:
geoloader load /path/to/geotiff.tif

# Load an individual Shapefile to Geoserver and Solr:
geoloader load /path/to/shapefile.shp

# Load all files matched by wildcard to Geoserver and Solr:
geoloader load /path/to/files/*

# Just load files to Geoserver:
geoloader load /path/to/files/* --services geoserver

# Just load files to Solr:
geoloader load /path/to/files/* --services solr

# Load files to a custom workspace:
geoloader load /path/to/files/* --workspace aerials

# Merge YAML-defined metadata into the Solr documents:
geoloader load /path/to/files/* --metadata /path/to/yaml

# Push the upload jobs onto a Resque queue:
geoloader load /path/to/files/* --queue

# Start a Resque worker on the Geoloader queue:
geoloader work

# List all existing workspaces with asset counts:
geoloader list
>>>
+------------+----------+
|       GEOLOADER       |
+------------+----------+
| Workspace  | # Assets |
+------------+----------+
| aerials    | 67       |
| cville     | 10       |
+------------+----------+

# Clear all assets in a workspace:
geoloader clear aerials
```

Ruby:

```ruby
# Load a Geotiff to Geoserver:
Geoloader::GeotiffGeoserverLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Geotiff to Solr:
Geoloader::GeotiffSolrLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Shapefile to Geoserver:
Geoloader::ShapefileGeotiffLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Load a Shapefile to Solr:
Geoloader::ShapefileSolrLoader.new("/path/to/file", "workspace", {:solr => "metadata"}).load

# Or use any of the loader classes as a Resque job:
Resque.enqueue(Geoloader::GeotiffSolrLoader, "/path/to/file", "workspace", {:solr => "metadata"})
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[geoserver]: http://geoserver.org/
[solr]: http://lucene.apache.org/solr/
[jeweler]: https://github.com/technicalpickles/jeweler
