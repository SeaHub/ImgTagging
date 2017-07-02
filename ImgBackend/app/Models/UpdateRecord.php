<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/25 0025
 * Time: 22:32
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class UpdateRecord extends Model
{
    public $table = 'update_record';


    protected $primaryKey = 'ur_id';


    public $timestamps = false;


    protected $fillable = [
        'i_id','filename','createTime','is_exec','t_id'
    ];


    protected $hidden = [

    ];


    protected $guarded = '';
}