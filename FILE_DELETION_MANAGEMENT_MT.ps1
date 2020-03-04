#defining global variables
    #   :$ENV        -- defining the servers environment
	#   :$CONFIGPATH -- location of configuration file
	#   :$CONFIGFILE -- file used to determine which files are to be deleted
	#	             -- and the volume of files to be deleted

    #   :$LOGPATH    -- path to retrieve deletion logs
    #   :$LOGNAME    -- name of log files generated  
 
$ENV = '\\WIN-S0HMNAFL489\'

$CONFIGPATH = $ENV + 'PATH\FILE_DELETION_MANAGEMENT\config\'
$CONFIGFILE = 'DELETION_MANAGEMENT.csv'
$FULL_CONFIG_PATH = $CONFIGPATH + $CONFIGFILE

$TODAYSLOGDATE = get-date -f yyyyMMdd
$LOGPATH    = $ENV + '\PATH\FILE_DELETION_MANAGEMENT\config\logs\'
$LOGNAME    = 'DELETION_LOG'
$FULL_LOG_PATH = $LOGPATH + $LOGNAME + '_' + $TODAYSLOGDATE + '.txt'


#loading the file into memory
$FILE_LIST = import-csv $FULL_CONFIG_PATH

#executing the file
	#   :$TARGET_PATH             -- location of file to be deleted
	#   :$TARGET_FILE             -- name of file to be searched for 
	#   :$TARGET_COUNT            -- number of files to keep from above parameters

foreach($i in $FILE_LIST){
	$TARGET_PATH = $ENV + $i.("Location") + '\*'
	$TARGET_FILE   = $i.("File Name")
	$TARGET_COUNT = $i.("Files to keep")
		

	#write-output $TARGET_PATH
	#write-output $TARGET_FILE

	get-childitem -path $TARGET_PATH -include $TARGET_FILE|
        Sort LastWriteTime -Descending|
        Select-Object -Skip $TARGET_COUNT |
        Tee-Object -FilePath $FULL_LOG_PATH -Append |
        Remove-Item -Verbose

}