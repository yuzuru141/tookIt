//
//  UrlViewController.m
//  tookIt
//
//  Created by 石井嗣 on 2015/05/05.
//  Copyright (c) 2015年 YuZ. All rights reserved.
//

#import "UrlViewController.h"

@interface UrlViewController (){
    UIWebView *webViewFromInternet;
    UITextField *textfieldWord;
    UITextField *textfieldURL;
    NSString *wordString;
    NSString* titleString;
    NSString* urlString;
    NSString *bodyString;
    UIButton *doneButton;
    UIButton *cancelButton;
    UIButton *resetButton;
    NSMutableArray *cellArray;
    NSMutableDictionary *cellDictionary;
    NSInteger cellNumber;
}

@end

@implementation UrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self firstLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)firstLoad{
    
    [self setLabelURL];
    
}

-(void)setLabelURL{
    
    [self loadUserDefault];
    
    //URL入力
    textfieldURL = [[UITextField alloc]initWithFrame:CGRectMake(20,20,self.view.bounds.size.width-40,20)];
    if (!(urlString==nil)) {
        textfieldURL.text = urlString;
//        NSLog(@"urlString=%@",urlString);
    }else{
        textfieldURL.text = @"http://";
    }
    textfieldURL.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
    textfieldURL.returnKeyType = UIReturnKeyDefault;
    textfieldURL.keyboardType = UIKeyboardTypeURL;
    textfieldURL.borderStyle = UITextBorderStyleRoundedRect;
    textfieldURL.tag = 0;
    textfieldURL.delegate = self;
    [textfieldURL becomeFirstResponder];
    [self.view addSubview:textfieldURL];
    
    doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(self.view.bounds.size.width/5,self.view.bounds.size.height-50,100,30);
    [doneButton setTitle:@"done" forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [doneButton addTarget:self
                   action:@selector(buttonDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resetButton.frame = CGRectMake(self.view.bounds.size.width/5*2,self.view.bounds.size.height-50,100,30);
    [resetButton setTitle:@"reset All" forState:UIControlStateNormal];
    resetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [resetButton addTarget:self
                     action:@selector(buttonreset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(self.view.bounds.size.width/5*3,self.view.bounds.size.height-50,100,30);
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelButton addTarget:self
                    action:@selector(buttonCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

-(void)loadUserDefault{
    
    cellArray = [[NSMutableArray alloc]init];
    cellDictionary = [[NSMutableDictionary alloc]init];
    NSUserDefaults* mydefault = [NSUserDefaults standardUserDefaults];
    cellNumber = [mydefault integerForKey:@"NUMBER"];
//    NSLog(@"(url)cellNumber=%d",cellNumber);
    cellArray = [mydefault objectForKey:@"CELLS"];
//    NSLog(@"(url)cellArray最初読み込み=%@",[cellArray description]);
//    NSLog(@"(url)cellarray count=%d",[cellArray count]);
    if (!(cellArray==nil)) {
        if ([cellArray count]>cellNumber) {
            cellDictionary = [cellArray objectAtIndex:cellNumber];
            urlString = [cellDictionary objectForKey:@"URL"];
            wordString = [cellDictionary objectForKey:@"SEARCHWORD"];
        }
    }
}



-(void)setLabelWord{
    
    //検索ワード入力
    textfieldWord = [[UITextField alloc]initWithFrame:CGRectMake(20,50,self.view.bounds.size.width-40,20)];
    if (!(wordString==nil)) {
        textfieldWord.text = wordString;
//        NSLog(@"wordString=%@",wordString);
    }else{
        textfieldWord.placeholder = NSLocalizedString(@"search word", nil);
    }
    textfieldURL.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:15];
    textfieldWord.returnKeyType = UIReturnKeyDefault;
    textfieldURL.keyboardType = UIKeyboardTypeDefault;
    textfieldWord.borderStyle = UITextBorderStyleRoundedRect;
    textfieldWord.tag = 1;
    textfieldWord.delegate = self;
    //    [textfieldWord becomeFirstResponder];
    [self.view addSubview:textfieldWord];
    
}


//textfieldでリターンキーが押されるとキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.tag==0){
        //WEB読み込み
        [self connectWeb:[NSURL URLWithString:textField.text]];
        [self setLabelWord];
    }
    return YES;
}






//internetから読み込む
- (void)connectWeb:(NSURL*)URLFROMTEXT{
    
    webViewFromInternet = [[UIWebView alloc]initWithFrame:CGRectMake(0,80,self.view.bounds.size.width,self.view.bounds.size.height-150)];
    
    webViewFromInternet.delegate = self;
    
    //    [BNIndicator showForView:webView withMessage:@"Loading"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URLFROMTEXT cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    NSHTTPURLResponse* resp;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:nil];
    
    //通信エラーであれば、警告を出す
    if (resp.statusCode != 200){
        [self alertViewMethod];
        return;
    }
    
    [webViewFromInternet loadRequest:request];
    [self.view addSubview:webViewFromInternet];
    
    [self webViewDidFinishLoad:webViewFromInternet];
    
}

//webViewで表示しているHTMLソースを取得する
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    titleString = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    urlString = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    bodyString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    //    NSLog(@"html body: %@", body);
    
}



//読み込み失敗時に呼ばれる関数
- (void)alertViewMethod{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"networkConncetionError", nil)
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK",nil];
    [alert show];
}


// 常に回転させない
- (BOOL)shouldAutorotate
{
    return NO;
}

// 縦のみサポート
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


//保存してページを戻る
- (void)buttonDone{
    
    wordString = textfieldWord.text;
    //検索
    //    [self searchWord:textfieldWord.text];
    //cellDictionary = [[NSMutableDictionary alloc]init];
    [cellDictionary setValue:titleString forKey:@"TITLE"];
    [cellDictionary setValue:urlString forKey:@"URL"];
    [cellDictionary setValue:wordString forKey:@"SEARCHWORD"];
//    NSLog(@"始めcellDictionary=%@",[cellDictionary description]);
    
    NSUserDefaults* mydefault = [NSUserDefaults standardUserDefaults];
    cellArray = [mydefault objectForKey:@"CELLS"];
//    NSLog(@"始めcellArray=%@",[cellArray description]);
    if (cellArray==NULL) {
        cellArray = [[NSMutableArray alloc]init];
    }
    if ([cellArray count]==cellNumber) {
        [cellArray addObject:cellDictionary];
    }else{
        [cellArray replaceObjectAtIndex:cellNumber withObject:cellDictionary];
    }
    [mydefault setObject:cellArray forKey:@"CELLS"];
    [mydefault synchronize];
//    NSLog(@"始めcellDictionary2=%@",[cellDictionary description]);
//   NSLog(@"始めcellArray2=%@",[cellArray description]);
    
    [self performSegueWithIdentifier:@"viewToTableView" sender:self];
    
}

//保存せずにページを戻る
- (void)buttonreset{
    [self performSegueWithIdentifier:@"viewToTableView" sender:self];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

//保存せずにページを戻る
- (void)buttonCancel{
    [self performSegueWithIdentifier:@"viewToTableView" sender:self];
}

@end

