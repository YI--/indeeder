
关于Indeed的接口 相关

搜索接口参数

http://api.indeed.com/ads/apisearch?publisher=9427261241958914&q=java&l=&limit=50&co=cn&userip=1.2.3.4&useragent=Mozilla&&v=2&format=json

参数
publisher:9427261241958914  出版商号                        必须值
v:1/2                       API版本1或者2
format: xml/json            返回数据为xml或者json              默认xml
callback:                   回调 适用于format=json           
q:java/ios                  查询 java/ios 职位
l:741600 天水 甘肃省天水市      位置 按邮编 按城市 按省市区         默认所有城市
sort:relevance/date         排序 相关性或者日期                  默认相关性
radius:100                  返回100个职位                        默认25
st:jobsite/employer         网站类型是找工作/雇主                默认求职者
jt:fulltime/parttime/contract/intemship/tempprary   职位类型:全职，兼职，合同，实习，临时  默认：全部
start:0                     100个职位从第0个开始                默认0
limit:5                    查询结果返回最大 5                 默认10
fromage:1                   按最近天数返回查询结果                       默认最近
highlight:1                 关键字高亮1                      默认0 不高亮
filter:0                    过滤重复的                       默认0 过滤
latlong:1                   如果为1 则返回每一个工作结果的经纬度信息   默认 0
co:cn                       在中国搜索
chnl:                       APL请求特定的频道
userip:                     请求时的用户编号                必须值
useragent:ios/android/Mozilla   用户通过什么访问            必须值

详细信息接口
http://api.indeed.com/ads/apigetjobs?publisher=9427261241958914&jobkeys=fef7cf979e9d34f8&v=2&format=json
参数
publisher:9427261241958914  出版商号                        必须值
v:1/2                       API版本1或者2
format: xml/json            返回数据为xml或者json              默认xml
jobkeys: key                查看当前key的详细信息



// 主接口


三个tabbar
1. 获取输入的信息 ios 天水 显示工作职位
2.全部的市  点击进入当前市的工作信息
3 我的界面  显示我的收藏 设置 等等


