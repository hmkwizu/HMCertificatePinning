Purpose
--------------

HMCertificatePinning is a class designed  to simplify SSL Certificate Pinning in Objective-C.

Supported OS & SDK Versions
-----------------------------

HMCertificatePinning works from iOS 6 and above.

ARC Compatibility
------------------

HMCertificatePinning requires ARC. If you wish to use HMCertificatePinning in a non-ARC project, just add the -fobjc-arc compiler flag to the HMCertificatePinning.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click HMCertificatePinning.m in the list and type -fobjc-arc into the popover.


Thread Safety
--------------

HMCertificatePinning is completely thread safe.

Installation
--------------

- Cocoapods

CocoaPods is the recommended way to add HMCertificatePinning to your project.

    Add a pod entry for HMCertificatePinning to your Podfile pod 'HMCertificatePinning', '~> 1.0.0'
    Install the pod(s) by running pod install.
    Include HMCertificatePinning wherever you need it with #import "HMCertificatePinning.h".


- Source files

To use HMCertificatePinning in an app, just drag the HMCertificatePinning class files into your project and add the Security framework.


Usage
-----

TODO.