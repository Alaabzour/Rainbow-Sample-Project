# How to Manage Contacts Rainbow 
## Retrieving existing contacts
Ask it directly to the contacts manager.
```
-(void) getRainbowNetwork {
NSArray<Contact *> * contacts = [ServicesManager sharedInstance].contactsManagerService.myNetworkContacts;   

NSLog(@"My Rainbow network %@", contacts);
}
```  

or you can also get contacts using notification of contacts manager:
kContactsManagerServiceDidAddContact
```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddContact:) name:kContactsManagerServiceDidAddContact object:nil];

-(void) didAddContact:(NSNotification *) notification {

Contact *contact = (Contact *)notification.object;
if(![contactsArray containsObject:contact])
[contactsArray addObject:contact];
}
```
## Managing contacts updates
You can monitor changes directly with notifications of contacts manager : 
kContactsManagerServiceDidUpdateContact

```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateContact:) name:kContactsManagerServiceDidUpdateContact object:nil];

-(void) didUpdateContact:(NSNotification *) notification {
Contact *contact = (Contact *)[notification.object objectForKey:@"contact"];
}
```

## Displaying contact full information
```
[[ServicesManager sharedInstance].contactsManagerService fetchRemoteContactDetail:_aContact];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetInfo:) name:kContactsManagerServiceDidUpdateContact object:nil];

-(void) didGetInfo:(NSNotification *) notification {
Contact *contact = (Contact *)[notification.object objectForKey:@"contact"];
}
```
## Searching for a contact by name
You can search contacts by name directly with following method : 
```
[[ServicesManager sharedInstance].contactsManagerService searchRemoteContactsWithPattern:searchedText withCompletionHandler:^(NSString *searchPattern, NSArray<Contact *> *foundContacts) {
NSLog(@"result : %@", foundContacts);
}];
```
## Adding the contact to the user network
You can add Rainbow user to your network or invie local contact to Rainbow using following Method:

```
[[ServicesManager sharedInstance].contactsManagerService inviteContact:_aContact];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInviteContact:) name:kContactsManagerServiceDidInviteContact object:nil];

-(void) didInviteContact:(NSNotification *) notification {
NSLog(@"added");
}
```
## Removing the contact from the user network
You can Remove Rainbow user from your network as follow:

```
[[ServicesManager sharedInstance].contactsManagerService removeContactFromMyNetwork:_aContact];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRemoveContact:) name:kContactsManagerServiceDidRemoveContact object:nil];

-(void) didRemoveContact:(NSNotification *) notification {
NSLog(@"deleted");
}
```

# Managing Presence of Contact
## Retrieving current user  presence
```
MyUser *currentUser = [[ServicesManager sharedInstance] myUser];
int selectedStatus = (int)currentUser.contact.presence.presence;
```
## Change user presence 
- You can change your presence using following Method with multiple choices
```
presenceAvailable
presenceAway
presenceExtendedAway
presenceDoNotDistrub

```

```
[[ServicesManager sharedInstance].contactsManagerService changeMyPresence:[Presence presenceAvailable]];
```

##  Listening to presence of contacts
You can get contact presense as follow,
```
NSLog(@"Presence: %@",aContact.presence");
```
