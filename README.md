# PLS-Java

## Prepare

put `.jar` file to `lib/` your want to import.

```
/
-- lib/
  -- xxxx.jar
  -- yyyy.jar
-- out/
```

## How to Use

### import .JAR file

Type Command below.

```
make import
```

Then, expanded to `src/` 

### Export .JAR file

#### All　Packages

Type Command below

```
make
```

#### Single Packages

If you want to export `XXXX.jar`, type below

```
make xxxx
```

Then, exported to `out/` 

