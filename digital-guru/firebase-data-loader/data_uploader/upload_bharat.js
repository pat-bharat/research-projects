// Imports
const firestoreService = require('firestore-export-import');
const firebaseConfig = require('./config-bharat.js');
const serviceAccount = require('./digital-guru-bharat-sa.json');

// JSON To Firestore
const jsonToFirestore = async () => {
  try {
	  const appName = 'digiguru-test'

    console.log('Initialzing Firebase');
    await firestoreService.initializeApp(serviceAccount);
    console.log('Firebase Initialized');

    await firestoreService.restore('./entity/user.json');	
    await firestoreService.restore('./entity/business.json');	
    await firestoreService.restore('./entity/business_user.json');
    await firestoreService.restore('./entity/business_legal.json');
    await firestoreService.restore('./entity/course.json');	
    await firestoreService.restore('./entity/module.json');	
    await firestoreService.restore('./entity/group.json');	
    await firestoreService.restore('./entity/module_media.json');
    await firestoreService.restore('./entity/lesson.json');	
    await firestoreService.restore('./entity/lesson_media.json');	
    await firestoreService.restore('./entity/instructor.json');	
    await firestoreService.restore('./entity/media.json');	
    await firestoreService.restore('./entity/user_preferance.json');
    await firestoreService.restore('./entity/user_module.json');
    await firestoreService.restore('./entity/user_media.json');
    await firestoreService.restore('./entity/course.json');		
    await firestoreService.restore('./entity/business_attributes.json');
    await firestoreService.restore('./entity/user_device.json');
    await firestoreService.restore('./entity/invoice.json');
    await firestoreService.restore('./entity/billing_item.json');	
    await firestoreService.restore('./entity/legal.json');
    
    
   // await firestoreService.restore('./entity/ids.json');	
    
       
    console.log('Upload Success');
  }
  catch (error) {
    console.log(error);
  }
};

jsonToFirestore();