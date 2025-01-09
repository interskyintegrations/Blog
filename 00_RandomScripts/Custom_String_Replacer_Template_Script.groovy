/*----------------------------------------------------/
Script Name: Custom String Replacer Template Script
Creation Date: 31-08-2023
Author: Jan Daris
Description: This script enables dynamic string replacement using process properties for search and replace.
Last Update Date: XX-XX-XXXX
Last Update By: Jan Daris
Last Update Description: Initial Script Creation
/----------------------------------------------------*/

/* Notes */
// For more complex scenarios, consider using document properties instead of process properties

import java.util.Properties
import java.io.InputStream
import com.boomi.execution.ExecutionUtil

/*-------- Do not modify below this line --------*/
for (int i = 0; i < dataContext.getDataCount(); i++) {
    InputStream is = dataContext.getStream(i)
    Properties props = dataContext.getProperties(i)
    /*----------------------------------*/

    // Set the following Dynamic Process Properties with the required values and execute this script to achieve the desired output.

    def fullString = ExecutionUtil.getDynamicProcessProperty("DPP_FullString") // Full string to search within
    def findString = ExecutionUtil.getDynamicProcessProperty("DPP_FindString") // Target string to find
    def replaceString = ExecutionUtil.getDynamicProcessProperty("DPP_ReplaceString") // String to replace the target string with

    def newFullString = fullString.replace(findString, replaceString)

    ExecutionUtil.setDynamicProcessProperty("DPP_FullString", newFullString, false) // Update DPP_FullString with the modified value

    /*-------- Do not modify below this line --------*/
    dataContext.storeStream(is, props)
}
/*----------------------------------*/
