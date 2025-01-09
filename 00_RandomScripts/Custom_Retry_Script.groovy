/*------------------------------------------------/
Script Name: Custom Scripting Retry Process Script
Creation Date: 30-08-2023
Author: Jan Daris
Description: This script manages exception handling from Custom Scripting, enabling retries before terminating the process.
Last Update Date: XX-XX-XXXX
Last Update By: Jan Daris
Last Update Description: Initial Script Creation
/-------------------------------------------------*/

/*Notes*/
// Ensure to create a Retry Count dynamic process Property and initialize it to 0 at the flow's start using the Set Properties Shape; this property tracks the retry count.
// Also, create a Retry dynamic process Property and initialize it with a static value at the flow's start using the Set Properties Shape; this property tracks whether a retry should continue or not.

import java.util.Properties;
import java.io.InputStream;
import com.boomi.execution.ExecutionUtil;

/*--------Do not modify below this line--------*/
for (int i = 0; i < dataContext.getDataCount(); i++) {
    InputStream is = dataContext.getStream(i);
    Properties props = dataContext.getProperties(i);
    /*----------------------------------*/

    // Define the maximum number of retries this process should handle.
    int maxRetry = 3;
    
    // Define the wait times for retries after the initial wait (0 seconds).
    def retryWait = [0, 60, 180, 300];
    
    // Retrieve the Dynamic Process Property used to store the retry count, assuming it has been previously initialized in the flow.
    String retryCountTemp = ExecutionUtil.getDynamicProcessProperty("<$RetryCount Dynamic Process Property Name$>");
    int retryCount = Integer.parseInt(retryCountTemp);  // Convert the Process Property into an integer for calculations.
    
    // Increment the retry count.
    retryCount = retryCount + 1;
    
    // Update the Dynamic Process Property with the new retry count.
    ExecutionUtil.setDynamicProcessProperty("<$RetryCount Dynamic Process Property Name$>", Integer.toString(retryCount), true);
    
    // Check if the retry count is within the maximum limit.
    if (retryCount <= maxRetry) {
        ExecutionUtil.setDynamicProcessProperty("<$Retry Dynamic Process Property Name$>", 'true', true); // Indicate that a retry is still required.
        int waitFor = retryWait[retryCount];
        Thread.sleep(waitFor * 1000); // Sleep for the appropriate wait time before the next retry.
    } else {
        ExecutionUtil.setDynamicProcessProperty("<$Retry Dynamic Process Property Name$>", 'false', true); // Indicate that retry is no longer required.
    }

    /*--------Do not modify below this line--------*/
    dataContext.storeStream(is, props);
}
/*----------------------------------*/"
