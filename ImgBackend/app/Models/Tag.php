<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/15 0015
 * Time: 20:40
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tag extends Model
{
    public $table = 'tag';


    protected $primaryKey = 't_id';


    public $timestamps = false;


    protected $fillable = [
        't_name'
    ];


    protected $hidden = [

    ];


    protected $guarded = '';

}