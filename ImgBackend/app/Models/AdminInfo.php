<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 20:38
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AdminInfo extends Model
{
    public $table='admin_info';


    protected $primaryKey='a_id';


    public $timestamps=false;


    protected $fillable = [
        'userId','name'
    ];


    protected $hidden = [

    ];


    protected $guarded='';
}