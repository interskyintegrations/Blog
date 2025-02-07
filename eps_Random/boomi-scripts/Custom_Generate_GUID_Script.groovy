/*------------------------------------------------/
Script Name: Custom_Generate_GUID_Script
Creation Date: 30-08-2023
Author: Jan Daris
Description: This script allows to generate a random guid into a process property
Last Update Date: XX-XX-XXXX
Last Update By: Jan Daris
Last Update Description: Initial Script Creation
/-------------------------------------------------*/

/*Notes*/
//  you can also use a document property instead of the process property to get a GUID per document within your process

import java.util.Properties;
import java.io.InputStream;

/*--------Do not modify below this line--------*/
for (int i = 0; i < dataContext.getDataCount(); i++) {
    InputStream is = dataContext.getStream(i);
    Properties props = dataContext.getProperties(i);
    /*----------------------------------*/

   // Specify the length of time to delay in seconds.
 
    def guid = UUID.randomUUID().toString()  
    ExecutionUtil.setDynamicProcessProperty("DPP_RandomGUID", guid.toString(), true);


    /*--------Do not modify below this line--------*/
    dataContext.storeStream(is, props);
}
/*----------------------------------*/
