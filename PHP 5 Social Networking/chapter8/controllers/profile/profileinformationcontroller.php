<?php

/**
 * Profile information controller
 */
class Profileinformationcontroller {
	
	/**
	 * Constructor
	 * @param Registry $registry
	 * @param int $user the user id
	 * @return void
	 */
	public function __construct( $registry, $user )
	{
		$this->registry = $registry;
		$urlBits = $this->registry->getObject('url')->getURLBits();
		if( isset( $urlBits[3] ) )
		{
			switch( $urlBits[3] )
			{
				case 'edit':
					$this->editProfile();
					break;
				default:
					$this->viewProfile( $user );
					break;
			}	
		}
		else
		{
			$this->viewProfile( $user );
		}
		
	}
	
	/**
	 * View a users profile information 
	 * @param int $user the user id
	 * @return void
	 */
	private function viewProfile( $user )
	{
		// load the template
		$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'profile/information/view.tpl.php', 'footer.tpl.php' );
		// get all the profile information, and send it to the template
		require_once( FRAMEWORK_PATH . 'models/profile.php' );
		$profile = new Profile( $this->registry, $user );
		$profile->toTags( 'p_' ); 
	}
	
/**
 * Edit your profile
 * @return void
 */
private function editProfile()
{
	if( $this->registry->getObject('authenticate')->isLoggedIn() == true )
	{
		$user = $this->registry->getObject('authenticate')->getUser()->getUserID();
		if( isset( $_POST ) && count( $_POST ) > 0 )
		{
			// edit form submitted
			$profile = new Profile( $this->registry, $user );
			$profile->setBio( $this->registry->getObject('db')->sanitizeData( $_POST['bio'] ) );
			$profile->setName( $this->registry->getObject('db')->sanitizeData( $_POST['name'] ) );
			$profile->setDinoName( $this->registry->getObject('db')->sanitizeData( $_POST['dino_name'] ) );
			$profile->setDinoBreed( $this->registry->getObject('db')->sanitizeData( $_POST['dino_breed'] ) );
			$profile->setDinoGender( $this->registry->getObject('db')->sanitizeData( $_POST['dino_gender'] ), false );
			$profile->setDinoDOB( $this->registry->getObject('db')->sanitizeData( $_POST['dino_dob'] ), false );
			if( isset( $_POST['profile_picture'] ) )
			{
				require_once( FRAMEWORK_PATH . 'lib/images/imagemanager.class.php' );
				$im = new Imagemanager();
				$im->loadFromPost( 'profile_picture', $this->registry->getSetting('uploads_path') .'profile/', time() );
				if( $im == true )
				{
					$im->resizeScaleHeight( 150 );
					$im->save( $this->registry->getSetting('uploads_path') .'profile/' . $im->getName() );
					$profile->setPhoto( $im->getName() );
				}
			}
			$profile->save();
			$this->registry->redirectUser( array('profile', 'view', 'edit' ), 'Profile saved', 'The changes to your profile have been saved', false );
		}
		else
		{
			// show the edit form
			$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'profile/information/edit.tpl.php', 'footer.tpl.php' );
			// get the profile information to pre-populate the form fields
			require_once( FRAMEWORK_PATH . 'models/profile.php' );
			$profile = new Profile( $this->registry, $user );
			$profile->toTags( 'p_' ); 
		}
	}
	else
	{
		$this->registry->errorPage('Please login', 'You need to be logged in to edit your profile');
	}
}
	
}


?>