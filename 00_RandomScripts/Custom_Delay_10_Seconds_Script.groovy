/*------------------------------------------------/
Script Name: Custom_Delay_10_Seconds_Script
Creation Date: 30-08-2023
Author: Jan Daris
Description: This script allows to implement delay in your Boomi process
Last Update Date: XX-XX-XXXX
Last Update By: Jan Daris
Last Update Description: Initial Script Creation
/-------------------------------------------------*/

/*Notes*/
//  none

import java.util.Properties;
import java.io.InputStream;

/*--------Do not modify below this line--------*/
for (int i = 0; i < dataContext.getDataCount(); i++) {
    InputStream is = dataContext.getStream(i);
    Properties props = dataContext.getProperties(i);
    /*----------------------------------*/

   // Specify the length of time to delay in seconds.

int delayFor = 10;
Thread.sleep(delayFor * 1000);


    /*--------Do not modify below this line--------*/
    dataContext.storeStream(is, props);
}
/*----------------------------------*/
