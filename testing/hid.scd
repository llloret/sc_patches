```
// Find available HID devices
HID.findAvailable

// Open the device. Subst (1133, 49798) with the IDs returned by findAvailable
h = HID.open(1133, 49798)

// Check the REPORT DESCRIPTOR
// 1. Collections
h.postCollections

// 2. Elements
h.postElements

// 3. Usages
h.postUsages

// 4. Only the input elements (should be a subset of 2. above)
h.postInputElements


// And now REPORTS
// HIDFunc allows to set callback when we get a report for a given element (or all). Or other filters.
// To compare between plaforms, we do a full match on ANY element
HIDFunc.usage( { |...args| args.postln; }, nil)

// In case you are interested in low level information about HID reports as they arrive:
// Enable trace (will give low level output about all the reports received) - VERY verbose if moving the joystick
HIDFunc.trace

// Deactivate the trace
HIDFunc.trace(false)



// Perhaps it would be useful (for more advanced testing), to set the callbacks to just an element, not all of them
// ....
// And call functions like findElementWithUsage (elUsage, elUsagePage)

HID.closeAll
```