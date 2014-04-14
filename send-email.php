<?php

// include swift-mailer
require_once './externals/swiftmailer/lib/swift_required.php';


// config
$config['gitmonitor']['send-from'] = 'git-monitor@domain.com';
$config['gitmonitor']['send-to'] = 'destination@domain.com';
$config['swiftmailer']['type'] = 'sendmail';
$config['swiftmailer']['sendmail']['path'] = '/usr/sbin/sendmail';
$config['swiftmailer']['sendmail']['options'] = '-bs';
$config['swiftmailer']['smtp']['host'] = 'pool.mn';
$config['swiftmailer']['smtp']['port'] = '25';
$config['swiftmailer']['smtp']['encryption'] = 'tls';
$config['swiftmailer']['smtp']['username'] = '';
$config['swiftmailer']['smtp']['password'] = '';

// parse parameters
$options = getopt('', array('subject:', 'body:'));
if ($options === false) {
    exit ('ERROR: Wrong script arguments. You must set --subject and --body');
}

// create and send email
$result = sendMail($config['gitmonitor']['send-from'],
                   $config['gitmonitor']['send-to'],
                   $options['subject'],
                   $options['body']);

if ($result == false) {
    exit ('ERROR: Failed to send e-mail');
}

function sendMail($sendFrom, $sendTo, $emailSubject, $emailBody)
{
    global $config;

    // Prepare SMTP transport and mailer
    $transport_type = $config['swiftmailer']['type'];
    if ($transport_type == 'sendmail') {
        $transport = Swift_SendmailTransport::newInstance($config['swiftmailer'][$transport_type]['path'] . ' ' . $config['swiftmailer'][$transport_type]['options']);
    } else if ($transport_type == 'smtp') {
        $transport = Swift_SmtpTransport::newInstance($config['swiftmailer']['smtp']['host'], $config['swiftmailer']['smtp']['port'], $config['swiftmailer']['smtp']['encryption']);
        if (!empty($config['switfmailer']['smtp']['username']) && !empty($config['switfmailer']['smtp']['password'])) {
            $transport->setUsername($config['switfmailer']['smtp']['username']);
            $transport->setPassword($config['switfmailer']['smtp']['password']);
        }
    } else {
        echo 'ERROR: Wrong swift-mailer config \n';
        return false;
    }
    $mailer = Swift_Mailer::newInstance($transport);


    // Create new message for SwiftMailer
    $message = Swift_Message::newInstance()
               ->setSubject($emailSubject)
               ->setFrom(array($sendFrom => $sendFrom))
               ->setTo(array($sendTo))
               ->setBody($emailBody);

    // Send message out with configured transport
    try {
        if ($mailer->send($message) != 0) {
            return true;
        } else {
            echo "ERROR: Zero recipients accepted e-mail \n";
            return false;
        }
    } catch (Exception $e) {
        echo 'ERROR: Caught exception: ', $e->getMessage(), "\n";
        return false;
    }
}