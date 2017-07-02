<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/26 0026
 * Time: 18:54
 */

namespace App\Models;


use Illuminate\Database\Eloquent\Model;

class SequenceRecord extends Model
{
    public $table='sequence_history';


    protected $primaryKey='id';


    public $timestamps=false;


    protected $fillable = [
        'userId','last_id'
    ];


    protected $hidden = [

    ];


    protected $guarded='';
}