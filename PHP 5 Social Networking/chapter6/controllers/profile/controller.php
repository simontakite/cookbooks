<?php

/**
 * Profile controller
 * Delegates control to profile controllers to seperate the distinct profile features
 */
class Profilecontroller {
	
	/**
	 * Constructor
	 * @param Object $registry the registry
	 * @param bool $directCall - are we directly accessing this controller?
	 */
	public function __construct( $registry, $directCall=true )
	{
		$this->registry = $registry;
		
		$urlBits = $this->registry->getObject('url')->getURLBits();
		switch( isset( $urlBits[1] ) ? $urlBits[1] : '' )
		{
			case 'view':
				$this->staticContentDelegator( intval( $urlBits[2] ) );
				break;
			case 'statuses':
				$this->statusesDelegator( intval( $urlBits[2] ) );
				break;
			default:
				$this->staticContentDelegator( $this->registry->getObject('authenticate')->getUser()->getUserID() );
				break;
		}	
	}
	
	/**
	 * Delegate control to the static content profile controller
	 * @param int $user the user whose profile we are viewing
	 * @return void
	 */
	private function staticContentDelegator( $user )
	{
		$this->commonTemplateTags( $user );
		require_once( FRAMEWORK_PATH . 'controllers/profile/profileinformationcontroller.php' );
		$sc = new Profileinformationcontroller( $this->registry, true, $user );	
	}
	
	/**
	 * Delegate control to the statuses profile controller
	 * @param int $user the user whose profile we are viewing
	 * @return void
	 */
	private function statusesDelegator( $user )
	{
		$this->commonTemplateTags( $user );
		require_once( FRAMEWORK_PATH . 'controllers/profile/profilestatusescontroller.php' );
		$sc = new Profilestatusescontroller( $this->registry, true, $user );	
	}
	
	/**
	 * Display an error - you cannot access profiles simply by visiting /profile/ !
	 * @return void
	 */
	private function profileError()
	{
		$this->registry->errorPage( 'Sorry, an error has occured', 'The link you followed was invalid, please try again');
	}
	
/**
 * Set common template tags for all profile aspects
 * @param int $user the user id
 * @return void
 */
private function commonTemplateTags( $user )
{

	
	// get a random sample of 6 friends.
	require_once( FRAMEWORK_PATH . 'models/relationships.php' );
	$relationships = new Relationships( $this->registry );
	$cache = $relationships->getByUser( $user, true, 6 );
	$this->registry->getObject('template')->getPage()->addTag( 'profile_friends_sample', array( 'SQL', $cache ) );
	
	// get the name and photo of the user
	require_once( FRAMEWORK_PATH . 'models/profile.php' );
	$profile = new Profile( $this->registry, $user );
	$name = $profile->getName();
	$photo = $profile->getPhoto(); 
	$uid = $profile->getID();

	$this->registry->getObject('template')->getPage()->addTag( 'profile_name', $name );
	$this->registry->getObject('template')->getPage()->addTag( 'profile_photo', $photo );
	$this->registry->getObject('template')->getPage()->addTag( 'profile_user_id', $uid );
	// clear the profile
	$profile = "";
}

	
}



?>