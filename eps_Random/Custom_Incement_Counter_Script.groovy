/*------------------------------------------------/
Script Name: Custom_Incement_Counter_Script
Creation Date: 30-08-2023
Author: Jan Daris
Description: This script allows to generate a counter in your process
Last Update Date: XX-XX-XXXX
Last Update By: Jan Daris
Last Update Description: Initial Script Creation
/-------------------------------------------------*/

/*Notes*/
//  you can also use a document property instead of the process property to set a counter per document, can be beneficial if process al steps first per doc

import java.util.Properties;
import java.io.InputStream;

/*--------Do not modify below this line--------*/
for (int i = 0; i < dataContext.getDataCount(); i++) {
    InputStream is = dataContext.getStream(i);
    Properties props = dataContext.getProperties(i);
    /*----------------------------------*/

  // Retrieve current Process Property value DDP_Count
    propValue = ExecutionUtil.getDynamicProcessProperty(DDP_Count);

    // Convert string value to int due Boomi
    int intValue = Integer.parseInt(propValue);
    bool = true;

    // Increment value by 1
    intValue = intValue + Integer.parseInt(ExecutionUtil.getDynamicProcessProperty('DDP_Count'));

    // Convert int value back to String
    propValue = Integer.toString(intValue);

    // Set the process property DDP_Count
    ExecutionUtil.setDynamicProcessProperty(DDP_Count, propValue, bool);


    /*--------Do not modify below this line--------*/
    dataContext.storeStream(is, props);
}
/*----------------------------------*/
