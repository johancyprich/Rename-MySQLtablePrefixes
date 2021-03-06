### APPLICATION: Rename-MySQLtablePrefixes
### VERSION: 1.0.0
### DATE: September 15, 2014
### AUTHOR: Johan Cyprich
### AUTHOR URL: www.cyprich.com
### AUTHOR EMAIL: jcyprich@live.com
###   
### LICENSE:
### The MIT License (MIT)
### "http://opensource.org/licenses/mit-license.php">###
###
### Copyright (c) 2014 Johan Cyprich. All rights reserved.
###
### Permission is hereby granted, free of charge, to any person obtaining a copy 
### of this software and associated documentation files (the "Software"), to deal
### in the Software without restriction, including without limitation the rights
### to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
### copies of the Software, and to permit persons to whom the Software is
### furnished to do so, subject to the following conditions:
###
### The above copyright notice and this permission notice shall be included in
### all copies or substantial portions of the Software.
###
### THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
### IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
### FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
### AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
### LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
### OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
### THE SOFTWARE.
###
### SUMMARY:
### Renames the prefixes in tables in a MySQL database. Requires the MySQL .NET Connector.

param
(
  [string] $oldExt,
  [string] $newExt
)


#=[ LIBRARIES ]=====================================================================================


[void][system.reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\MySQL Connector Net 6.9.3\Assemblies\v4.5\MySQL.Data.dll")
#void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")


#=[ GLOBALS ]=======================================================================================


[string] $host = 'server'
[string] $database = 'database'
[string] $user = 'user'
[string] $password = 'password'


#=[ FUNCTIONS ]=====================================================================================


####################################################################################################
### SUMMARY:
### Renames the prefix in a table.
###
### PARAMETERS:
### table (in): Table to rename.
####################################################################################################

function RenameTable
{
  param
  (
    $table
  )
  
  $sql = "RENAME TABLE $table TO " + $table.Replace($oldExt, $newExt)

  $myconnection2 = New-Object MySql.Data.MySqlClient.MySqlConnection
  $myconnection2.ConnectionString = "server=$host;userid=$user;password=$password;database=$database;pooling=false"
  $myconnection2.Open()
  $mycommand2 = New-Object MySql.Data.MySqlClient.MySqlCommand  
  $mycommand2.Connection = $myconnection2
  $mycommand2.CommandText = $sql
  $myreader2 = $mycommand2.ExecuteReader()
}


####################################################################################################
### SUMMARY:
### Writes the name of the app, copyright, license, and branding.
###
### PARAMTERS:
### $appName (in) - Name of the app.
### $copyright (in) -  Year and copyright name.
### $appFore (in) - Foreground colour of $appName (default White).
### $appBack (in) - Background colour of $appName (default DarkBlue).
### $copyFore (in) - Foreground colour of $copyright (default Black).
### $copyBlack (in) - Background colour of $copyright (default DarkGray).
####################################################################################################

function WriteProgramInfo
{
  param
  (
    [string] $appName, 
    [string] $copyright,
    [string] $appFore = "White",
    [string] $appBack = "DarkBlue",
    [string] $copyFore = "Black",
    [string] $copyBack = "DarkGray"    
  )
  
  [string] $copyrt = " Copyright (C) $copyright. All rights reserved. "
  [string] $license = " Licensed under The MIT License (MIT)."
  [int] $copyrtLength = $copyrt.length
  [string] $linePadding
  [string] $emptyLine = " " * $copyrtLength  
  
  # Write app info and pad with spaces based on the length of the copyright line.
  
  Write-Host ""
  Write-Host $emptyLine -ForegroundColor $appFore -BackgroundColor $appBack
  
  $linePadding = " " * ($copyrtLength - " $appName".length)
  Write-Host " $appName$linePadding" -ForegroundColor $appFore -BackgroundColor $appBack
  
  Write-Host $emptyLine -ForegroundColor $appFore -BackgroundColor $appBack
  Write-Host $emptyLine -ForegroundColor $copyFore -BackgroundColor $copyBack
  Write-Host $copyrt -ForegroundColor $copyFore -BackgroundColor $copyBack
  
  $linePadding = " " * ($copyrtLength - " $license".length)
  Write-Host " Licensed under The MIT License (MIT). $linePadding" -ForegroundColor $copyFore -BackgroundColor $copyBack

  Write-Host $emptyLine -ForegroundColor $copyFore -BackgroundColor $copyBack
  Write-Host ""
} # WriteProgramInfo


#=[ MAIN ]==========================================================================================


$ErrorActionPreference = 'SilentlyContinue'

WriteProgramInfo "Backup-MySQL 2.0.0" "2014"
Write-Host ""


$myconnection = New-Object MySql.Data.MySqlClient.MySqlConnection
$myconnection.ConnectionString = "server=$host;userid=$user;password=$password;database=$database;pooling=false"
$myconnection.Open()

# Create a variable to hold the command:
$mycommand = New-Object MySql.Data.MySqlClient.MySqlCommand

# Set the command's connection property to our connection variable:
$mycommand.Connection = $myconnection

# Set the command text:
$mycommand.CommandText = "SHOW TABLES"

# Instantiate a reader variable and set it to the results of the command object's ExecuteReader() method:
$myreader = $mycommand.ExecuteReader()

#Display the results of the Read() method as long as there are results:

while($myreader.Read())
{
  Write-Host $myreader.GetString(0) 
  RenameTable $myreader.GetString(0)  
}
