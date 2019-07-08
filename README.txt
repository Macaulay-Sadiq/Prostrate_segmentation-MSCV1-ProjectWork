
Running The GUI

Loading Image into workspace:
    1) Click on the  push button 
    2) on the displayed window,  browse the folder containing images (folder is expected to contain ‘.dcm’ file extension), all the required files in the folder are imported into the work space and the first image file  and its corresponding data is displayed on the GUI axis by default.

Previewing image files:
	If image directory is successfully loaded to workspace, we can now sequentially display the 	images in the image in the directory with their corresponding information on the GUI
    1. Click on  and    push buttons to view next and previous image and image- info on the GUI            
    2. each image and its corresponding information are displayed on the GUI as follows
       

Anonymize DICOM information:
    1. DICOM data can be anonymized by clicking on   push button on the ‘Tools’ panel:
	this will create a new folder in which new ‘.dcm’ file extension are created with anonymous  	PatientName, PatientID, and BirthDate. The working directory is as well updated with the 	anonymized DICOM files and can be viewed with the  and  push button.
      2. 	Information about the operation is displayed in the text box below the axis.

Converting DICOM images to JPG:
    1. By clicking on the  push button in ‘ Tools’ panel, a new folder is created and the current DICOM images in the work space are converted to ‘.jpg’ file extension with their corresponding ‘.mat’ file which contains the image information. This files are then saved in the new folder.
    2. Information about the operation is displayed in the text box below the axis.


Converting the JPG image into DICOM format:
    1. By clicking on the  push button on the ‘Tools’ panel, a new folder is created in the working directory and files that were previous created in the ‘Converting DICOM images to JPG’ operation are converted back to DICOM images considering both the .jpg and .mat file. The DICOM files are saved in the newly created folder.
    2. Information about the operation is displayed in the text box below the axis.

Segmentation:
    1. By clicking on   push button, you will have to wait for the instructions displayed on the text box below the axis to draw contours of tumor, ZC, ZP, ZT, consecutively
    2. The result of the region drawn for segments are displayed on the right axis in red (tumor), green (ZC), blue (ZP) and white (ZT) 
					
    3. Area and volume of each segmented part are as well displayed below the right axis 
					
    4. A new image can be segmented with the use of the  and  push buttons.

Saving Image:
    1. By clicking on the  the current image on the right axis is saved to to a folder in the workspace with a ‘.jpg’ file extension.
    2. Information about the operation is displayed in the text box below the axis.

3D Visualization:
    1. By clicking on the  you will need to follow the guide on the text box below the axis to draw contours to be segmented through a number of slice defined by in program (this seems tiring) 
    2. 3D image of contours are displayed on the right axis after successfully operation of drawings.
    3. Information of area and volume of each contour is displayed below the left axis after drawing contours for each slice
    4. Information about the operation is displayed in the text box below the axis.
