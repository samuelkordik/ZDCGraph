# ZDCGraph
ZDCGraph is an app built in R using Shiny to generate graphs of vital sign trends obtained from Zoll patient monitors.

## Self-Contained Setup
[Download setup here](https://app.box.com/s/8kvsvdo1x3vchax9m35km5sh1nr8m243)

## Use
ZDCGraph requires R, with the following packages installed: stringr, shiny, reshape2, ggplot2, scales. It's possible to package it for easy distribution using R-Portable and Google Chrome Portable, with [these instructions](http://www.r-bloggers.com/deploying-desktop-apps-with-r/).

Once ZDCGraph has been launched, it requires a text "Trends" file. This can be obtained using Zoll Code Review's export functions to export a second-by-second copy of the vital signs.

Upload this text file to the app, and it will produce an onscreen graph. The start and end times can be manipulated using the slider. The image render of the graph can be copied or saved, and a DownloadPDF button will generate a PDF version of what's seen on the screen.

This was developed using Code Review 5.7.1 and Zoll X-Series monitors.

## Copyrights
This app is copyright (c) 2016 by Samuel Kordik and Cypress Creek EMS. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Zoll, Code Review, and X-Series are trademarks of Zoll Medical Corporation.

## Disclaimer
The authors are not liable for any breaches of data or PHI that occur from running this code. Use at your own risk. It is recommended that this app be run locally on a machine which you or your organization controls and that all PHI and healthcare data is treated following your organizational policies and standards.
