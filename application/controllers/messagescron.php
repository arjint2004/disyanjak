<?php
/**
 * Kalkun
 * An open source web based SMS Management
 *
 * @package		Kalkun
 * @author		Kalkun Dev Team
 * @license		http://kalkun.sourceforge.net/license.php
 * @link		http://kalkun.sourceforge.net
 */

// ------------------------------------------------------------------------

/**
 * Messages Class
 *
 * @package		Kalkun
 * @subpackage	Messages
 * @category	Controllers
 */
class Messagescron extends MY_Controller {

	/**
	 * Constructor
	 *
	 * @access	public
	 */
	function __construct()
	{
		parent::__construct();
		
		// session check
		//if ($this->session->userdata('loggedin')==NULL) redirect('login');
		//$param['uid'] = $this->session->userdata('id_user');
		
		$this->load->model('Phonebook_model');
		$this->load->library('Plugins');
	}
	
	 
	public function daemon_sb()
	{
		//echo phpinfo();
		$token='YToyOntzOjg6InVzZXJuYW1lIjtzOjI6InNiIjtzOjg6InBhc3N3b3JkIjtzOjE5OiJzdHVkZW50Ym9vayEqJCVeJiMkIjt9';
		$datain=file_get_contents('https://studentbook.co/akademik/daemond/md/'.$token.'');
		$datatdec=unserialize(base64_decode($datain));
		
		//echo "<pre>";
		//print_r($datatdec);
		
		$this->load->model(array('Kalkun_model', 'Message_model'));
	    $this->load->model('server_alert/server_alert_model', 'plugin_model');
	    
		//$tmp_data = $this->plugin_model->get('active');
		foreach($datatdec as $tmp)
		{
				$data['coding'] = 'default';	
				$data['message'] = $tmp['pesan'];
				$data['date'] = date('Y-m-d H:i:s');
				$data['dest'] = $tmp['no_hp'];
				$data['delivery_report'] = 'default';
				$data['class'] = '1';
				$data['uid'] = '1';
				$idupdate[]=$tmp['id'];
				$this->Message_model->send_messages($data);
		}
		$iddel=base64_encode(implode(",",$idupdate));
		$datadell=file_get_contents('https://studentbook.co/akademik/daemond/mdupdate/'.$token.'/'.$iddel.'');
		echo "<pre>";
		print_r($datadell);
		//print_r($_SERVER);
		
	}
	
	 

}	

/* End of file messages.php */
/* Location: ./application/controllers/messages.php */ 
