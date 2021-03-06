//
//  VVAttributionViewController.m
//  Vandy Vans
//
//  Created by Seth Friedman on 5/6/13.
//  Copyright (c) 2013 VandyApps. All rights reserved.
//

#import "VVAttributionViewController.h"

@interface VVAttributionViewController ()

@property (strong, nonatomic) NSAttributedString *attributionText;

@end

@implementation VVAttributionViewController

#pragma mark - Custom Getter

- (NSAttributedString *)attributionText {
    if (!_attributionText) {
        
        NSMutableAttributedString *MITLicenseAttributions = [self MITLicenseAttributions];
        [MITLicenseAttributions appendAttributedString:[self SVProgressHUDAttribution]];
        
        _attributionText = MITLicenseAttributions;
    }
    
    return _attributionText;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.attributionTextView.attributedText = self.attributionText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

- (NSMutableAttributedString *)MITLicenseAttributions {
    NSMutableAttributedString *MITLicenseAttributions = [[NSMutableAttributedString alloc] initWithString:@"\nThe following packages are distributed under the MIT License:\n\n"];
    [MITLicenseAttributions appendAttributedString:[self AFNetworkingAttribution]];
    [MITLicenseAttributions appendAttributedString:[self SAMTextViewAttribution]];
    [MITLicenseAttributions appendAttributedString:[self SAMCategoriesAttribution]];
    [MITLicenseAttributions appendAttributedString:[self MITLicenseText]];
    
    return MITLicenseAttributions;
}

- (NSAttributedString *)AFNetworkingAttribution {
    return [self packageAttributionWithPackageName:@"AFNetworking" copyrightLine:@"Copyright (c) 2013 AFNetworking (http://afnetworking.com/)"];
}

- (NSAttributedString *)SAMTextViewAttribution {
    return [self packageAttributionWithPackageName:@"SAMTextView" copyrightLine:@"Copyright (c) 2010-2014 Sam Soffes, http://soff.es"];
}

- (NSAttributedString *)SAMCategoriesAttribution {
    return [self packageAttributionWithPackageName:@"SAMCategories" copyrightLine:@"Copyright (c) 2008-2014 Sam Soffes, http://soff.es"];
}

- (NSAttributedString *)SVProgressHUDAttribution {
    NSAttributedString *GlyphishAttribution = [[NSAttributedString alloc] initWithString:@"A different license may apply to other resources included in this package, including Joseph Wain's Glyphish Icons. Please consult their respective headers for the terms of their individual licenses."];
    NSMutableAttributedString *SVProgressHUDAttribution = [[self packageAttributionWithPackageName:@"SVProgressHUD" copyrightLine:@"Copyright (c) 2011 Sam Vermette"] mutableCopy];
    [SVProgressHUDAttribution appendAttributedString:[self MITLicenseText]];
    [SVProgressHUDAttribution appendAttributedString:GlyphishAttribution];
    
    return [SVProgressHUDAttribution copy];
}

- (NSAttributedString *)MITLicenseText {
    return [[NSAttributedString alloc] initWithString:@"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n"];
}

- (NSAttributedString *)packageAttributionWithPackageName:(NSString *)packageName copyrightLine:(NSString *)copyrightLine {
    NSMutableAttributedString *attributedPackageName = [[NSMutableAttributedString alloc] initWithString:packageName attributes:@{NSFontAttributeName : [UIFont italicSystemFontOfSize:12.0f]}];
    NSMutableAttributedString *attributedCopyrightLine = [[NSMutableAttributedString alloc] initWithString:[[@"\n\n" stringByAppendingString:copyrightLine] stringByAppendingString:@"\n\n"]];
    
    [attributedPackageName appendAttributedString:attributedCopyrightLine];
    
    return attributedPackageName;
}

@end
