<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/23 0023
 * Time: 2:20
 */

namespace App\Exceptions;


class ResultException extends \Symfony\Component\HttpKernel\Exception\HttpException
{
    public function __construct($statusCode, $message = null)
    {
        $message = $message ?: 'result error!';
        parent::__construct($statusCode, $message);
    }
}