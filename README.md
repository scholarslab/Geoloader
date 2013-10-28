# Geoloader

Geoloader is a little gem that automates the process of loading [GeoTIFFs][geotiff] and [Shapfiles][shapefile] into the services that power the geospatial search interface at the University of Virginia Library - [PostGIS][postgis], [Geoserver][geoserver], and [Solr][solr].

## Installation and Configuration

For now, while things are still in development, install the gem by cloning this repository and using the [Jeweler][jeweler] rake task:

```
rake install
```

Then, you'll need to point Geoloader at instances of PostgreSQL, Geoserver, and Solr. Depending on whether you're using Geoloader programmatically in code or as a command-line program, this is done a bit differently. By default, Geoloader uses the settings defined in the top-level `config.yaml` file:

```yaml
postgres:
  host:       localhost
  port:       5432
  username:   admin
  password:   postgres

geoserver:
  url:        http://localhost:8080/geoserver
  username:   admin
  password:   geoserver
  srs:        EPSG:900913

solr:
  url:        http://localhost:8080/solr/geoloader

test:
  workspace:  gl_test
```

Depending on your needs, you can override some or all of these settings. For example, you'll almost always need to set custom login credentials for PostgreSQL and Geoserver. If you're using Geoloader programmatically in code, just use the top-level `configure` and `configure_from_yaml` methods:

```ruby
require "geoloader"

Geoloader.configure({
  :postgres => {
    :username => "pg_username",
    :username => "pg_password",
  },
  :geoserver => {
    :username => "gs_username",
    :username => "gs_password",
  },
})
```

Or, put your custom settings in a separate YAML file:

```yaml
# geoloader.yaml:

postgres:
  username: pg_username
  password: pg_password

geoserver:
  username: gs_username
  password: gs_password
```

And merge in the custom settings in bulk:

```ruby
require "geoloader"

Geoloader.configure_from_yaml("/path/to/geoloader.yaml")
```

If you're using Geoloader from the command line, **set global configuration defaults in a `~/.geoloader.yaml` file**, which is automatically loaded and applied before tasks are executed.

## Usage

Individual assets can be loaded programmatically by instantiating one of the two loader classes with a filename and a metadata hash:

```ruby
require "geoloader"

# Push a GeoTIFF to Geoserver and Solr:
geotiff_loader = Geoloader::GeotiffLoader.new("/path/to/geotiff.tif", {
  :WorkspaceName => "workspace",
  :LayerDisplayName => "Layer Name",
  :Abstract => "Layer description."
})

geotiff_loader.load

# Push a Shapefile to PostGIS, Geoserver, and Solr:
shapefile_loader = Geoloader::ShapefileLoader.new("/path/to/shapefile.shp", {
  :WorkspaceName => "workspace",
  :LayerDisplayName => "Layer Name",
  :Abstract => "Layer description."
})

shapefile_loader.load
```

For now, Geoloader assumes that the Solr core implements the [OpenGeoportal Solr config][ogp-solr], and the metadata hash can include any fields defined by the schema.

### CLI Application

Alternatively, batches of assets be loaded in bulk from the command line by defining a separate "manifest" YAML file that defines (a) a set of files that should be included in the upload and (b) a common packet of metadata that should be used to describe the assets in Solr.

#### load

First, create a manifest file, which can sit anywhere on the filesystem:

```yaml

files: "/path/to/assets/*"  # required
WorkspaceName: "aerials"    # required

LayerDisplayName: "Geoloader Development"
Abstract: "1937 Aerials of Charlottesville, Virginia."
# ... other metadata ...
```

The `files` and `WorkspaceName` fields are required, and the manifest can optionally define any other fields included in the Solr schema. To load the manifest, run:

```
geoloader load path/to/manifest.yaml
```

If you have access to Redis, add the `--queue` / `-q` flag on the command to push the job onto a Resque queue.

```
geoloader load path/to/manifest.yaml -q
```

#### work

Then, at any point in the future, start the job by spinning up a Resque worker:

```
geoloader work
```

#### list

To view a list of existing workspaces and the number of assets they contain, use the `list` task:

```
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
```

#### clear

Use the `clear` command to delete all assets in a workspace:

```
geoloader clear aerials
```

[geotiff]: http://en.wikipedia.org/wiki/Geotiff
[shapefile]: http://en.wikipedia.org/wiki/Shapefile
[postgis]: http://postgis.net/
[geoserver]: http://geoserver.org/
[solr]: http://lucene.apache.org/solr/
[jeweler]: https://github.com/technicalpickles/jeweler
[ogp-solr]: https://github.com/OpenGeoportal/ogpSolrConfig
