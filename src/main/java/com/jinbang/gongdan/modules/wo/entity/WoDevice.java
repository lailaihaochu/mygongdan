package com.jinbang.gongdan.modules.wo.entity;

import com.jinbang.gongdan.common.utils.excel.annotation.ExcelField;
import com.jinbang.gongdan.modules.sys.entity.Area;
import org.hibernate.validator.constraints.Length;
import com.jinbang.gongdan.modules.sys.entity.Office;

import com.jinbang.gongdan.common.persistence.DataEntity;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;


/**
 * 设备信息相关Entity
 *
 * @author 于鹏杰
 * @version 2017-04-12
 */
public class WoDevice extends DataEntity<WoDevice> {

    private static final long serialVersionUID = 1L;

    private ClientArea woArea;//所属区域
    private ClientArea woCity;//所属城市
    private DevPosition woBuild;//所属大楼
    private DevPosition woFloor;//所属楼层
    private DevPosition woRoom;//所属房间

    private WoClient woClient;        // 归属客户
    private WoStation woStation;    //归属站点
    private DeviceCategory deviceType1; //设备类型1
    private DeviceCategory deviceType2; //设备类型2
    private DeviceCategory deviceType3; //设备类型3
    private String deviceBrand; //设备品牌
    private String deviceModel; //设备型号
    private String devCode;     //设备编号
    private String name;        // 名称
    private String assetCode; // 固定资产编号
    private String snCode;  //SN编号
    private Date onLineDate;    //上线日期

    private String keyParams;//关键参数

    private String memo;//设备描述

    private String devStatus;//设备状态 (1、启用2、停用3、维修4、退出(默认启用))

    private String supplier;//供应商
    private String supplierPhone;//供应商联系方式
    private String supplierMan;//供应商联系人

    private Date manufactureDate;//出厂日期
    private Date repairStartDate;//保修开始日期
    private Date repairEndDate;//保修截止日期

    private String serviceLevel;//服务级别 (1、5*8  2、7*8  3、7*24)

    private Date serviceStartDate;//服务开始日期
    private Date serviceEndDate;//服务结束日期

    private Date beginServiceStartDate;//查询服务开始日期开始
    private Date endServiceStartDate;//查询服务开始日期结束
    private Date beginServiceEndDate;//查询服务结束日期开始
    private Date endServiceEndDate;//查询服务结束日期结束
    private Date beginRepairEndDate;//查询保修截止日期开始
    private Date endRepairEndDate;//查询保修截止日期结束

    public WoDevice() {
        super();
    }

    public WoDevice(String id) {
        super(id);
    }

    @ExcelField(title="归属客户", align=2, sort=300,fieldType=WoClient.class)
    public WoClient getWoClient() {
        return woClient;
    }
    public void setWoClient(WoClient woClient) {
        this.woClient = woClient;
    }

    @ExcelField(title="归属站点", align=2, sort=80,fieldType=WoStation.class)
    public WoStation getWoStation() {
        return woStation;
    }

    public void setWoStation(WoStation woStation) {
        this.woStation = woStation;
    }

    @Length(min = 1, max = 200, message = "设备品牌长度必须介于 1 和 200 之间")
    @ExcelField(title="品牌", type=0, align=1, sort=190)
    public String getDeviceBrand() {
        return deviceBrand;
    }

    public void setDeviceBrand(String deviceBrand) {
        this.deviceBrand = deviceBrand;
    }

    @Length(min = 1, max = 200, message = "设备型号长度必须介于 1 和 200 之间")
    @ExcelField(title="型号", type=0, align=1, sort=200)
    public String getDeviceModel() {
        return deviceModel;
    }

    public void setDeviceModel(String deviceModel) {
        this.deviceModel = deviceModel;
    }

    @Length(min = 1, max = 200, message = "设备编号长度必须介于 1 和 200 之间")
    public String getDevCode() {
        return devCode;
    }

    public void setDevCode(String devCode) {
        this.devCode = devCode;
    }

    @Length(min = 1, max = 200, message = "名称长度必须介于 1 和 200 之间")
    @ExcelField(title="设备名称", align=0, sort=20)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Length(min = 1, max = 200, message = "固定资产编号长度必须介于 1 和 200 之间")
    @ExcelField(title="资产编号", align=0, sort=10)
    public String getAssetCode() {
        return assetCode;
    }

    public void setAssetCode(String assetCode) {
        this.assetCode = assetCode;
    }

    //@Length(min = 1, max = 200, message = "SN编号长度必须介于 1 和 200 之间")
    @ExcelField(title="SN号", align=0, sort=60)
    public String getSnCode() {
        return snCode;
    }

    public void setSnCode(String snCode) {
        this.snCode = snCode;
    }

    @DateTimeFormat(pattern="yyyy-MM-dd")
    @ExcelField(title="上线日期", type=0, align=1, sort=50)
    public Date getOnLineDate() {
        return onLineDate;
    }

    public void setOnLineDate(Date onLineDate) {
        this.onLineDate = onLineDate;
    }

    @ExcelField(title="关键参数", align=0, sort=70)
    public String getKeyParams() {
        return keyParams;
    }

    public void setKeyParams(String keyParams) {
        this.keyParams = keyParams;
    }

    @ExcelField(title="设备描述", align=0, sort=30)
    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    @ExcelField(title="供应商", type=0, align=1, sort=250)
    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    @ExcelField(title="供应商联系电话", type=0, align=1, sort=270)
    public String getSupplierPhone() {
        return supplierPhone;
    }

    public void setSupplierPhone(String supplierPhone) {
        this.supplierPhone = supplierPhone;
    }

    @ExcelField(title="供应商联系人", type=0, align=1, sort=260)
    public String getSupplierMan() {
        return supplierMan;
    }

    public void setSupplierMan(String supplierMan) {
        this.supplierMan = supplierMan;
    }

    @ExcelField(title="出厂日期", type=0, align=1, sort=40)
    public Date getManufactureDate() {
        return manufactureDate;
    }

    public void setManufactureDate(Date manufactureDate) {
        this.manufactureDate = manufactureDate;
    }

    @ExcelField(title="保修开始日期", type=0, align=1, sort=280)
    public Date getRepairStartDate() {
        return repairStartDate;
    }

    public void setRepairStartDate(Date repairStartDate) {
        this.repairStartDate = repairStartDate;
    }

    @ExcelField(title="保修截止日期", type=0, align=1, sort=290)
    public Date getRepairEndDate() {
        return repairEndDate;
    }

    public void setRepairEndDate(Date repairEndDate) {
        this.repairEndDate = repairEndDate;
    }

    @ExcelField(title="服务开始日期", type=0, align=1, sort=220)
    public Date getServiceStartDate() {
        return serviceStartDate;
    }

    public void setServiceStartDate(Date serviceStartDate) {
        this.serviceStartDate = serviceStartDate;
    }

    @ExcelField(title="服务终止日期", type=0, align=1, sort=230)
    public Date getServiceEndDate() {
        return serviceEndDate;
    }

    public void setServiceEndDate(Date serviceEndDate) {
        this.serviceEndDate = serviceEndDate;
    }

    @ExcelField(title="设备状态", type=0, align=1, sort=210,dictType="device_status")
    public String getDevStatus() {
        return devStatus;
    }
    public void setDevStatus(String devStatus) {
        this.devStatus = devStatus;
    }

    @ExcelField(title="服务级别", type=0, align=1, sort=240,dictType="service_level")
    public String getServiceLevel() {
        return serviceLevel;
    }

    public void setServiceLevel(String serviceLevel) {
        this.serviceLevel = serviceLevel;
    }

    @ExcelField(title = "设备类型1", align = 2, sort = 160,fieldType=DeviceCategory.class)
    public DeviceCategory getDeviceType1() { return deviceType1; }

    public void setDeviceType1(DeviceCategory deviceType1) {
        this.deviceType1 = deviceType1;
    }

    @ExcelField(title = "设备类型2", align = 2, sort = 170,fieldType=DeviceCategory.class)
    public DeviceCategory getDeviceType2() {
        return deviceType2;
    }

    public void setDeviceType2(DeviceCategory deviceType2) {
        this.deviceType2 = deviceType2;
    }

    @ExcelField(title = "设备类型3", align = 2, sort = 180,fieldType=DeviceCategory.class)
    public DeviceCategory getDeviceType3() {
        return deviceType3;
    }

    public void setDeviceType3(DeviceCategory deviceType3) {
        this.deviceType3 = deviceType3;
    }

    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getBeginServiceStartDate() {
        return beginServiceStartDate;
    }

    public void setBeginServiceStartDate(Date beginServiceStartDate) {
        this.beginServiceStartDate = beginServiceStartDate;
    }

    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getEndServiceStartDate() {
        return endServiceStartDate;
    }

    public void setEndServiceStartDate(Date endServiceStartDate) {
        this.endServiceStartDate = endServiceStartDate;
    }

    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getBeginServiceEndDate() {
        return beginServiceEndDate;
    }

    public void setBeginServiceEndDate(Date beginServiceEndDate) {
        this.beginServiceEndDate = beginServiceEndDate;
    }

    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getEndServiceEndDate() {
        return endServiceEndDate;
    }

    public void setEndServiceEndDate(Date endServiceEndDate) {
        this.endServiceEndDate = endServiceEndDate;
    }

    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getBeginRepairEndDate() {
        return beginRepairEndDate;
    }

    public void setBeginRepairEndDate(Date beginRepairEndDate) {
        this.beginRepairEndDate = beginRepairEndDate;
    }

    @DateTimeFormat(pattern="yyyy-MM-dd")
    public Date getEndRepairEndDate() {
        return endRepairEndDate;
    }

    public void setEndRepairEndDate(Date endRepairEndDate) {
        this.endRepairEndDate = endRepairEndDate;
    }

    @ExcelField(title="所属区域", align=2, sort=310,fieldType = ClientArea.class)
    public ClientArea getWoArea() { return woArea;}
    public void setWoArea(ClientArea woArea) {
        this.woArea = woArea;
    }

    @ExcelField(title="所属城市", align=2, sort=320,fieldType = ClientArea.class)
    public ClientArea getWoCity() {
        return woCity;
    }
    public void setWoCity(ClientArea woCity) {
        this.woCity = woCity;
    }

    @ExcelField(title="所属大楼", align=2, sort=330,fieldType = DevPosition.class)
    public DevPosition getWoBuild() {
        return woBuild;
    }
    public void setWoBuild(DevPosition woBuild) {
        this.woBuild = woBuild;
    }

    @ExcelField(title="所属楼层", align=2, sort=340,fieldType = DevPosition.class)
    public DevPosition getWoFloor() {
        return woFloor;
    }
    public void setWoFloor(DevPosition woFloor) {
        this.woFloor = woFloor;
    }

    @ExcelField(title="所属房间", align=2, sort=350,fieldType = DevPosition.class)
    public DevPosition getWoRoom() {
        return woRoom;
    }
    public void setWoRoom(DevPosition woRoom) {
        this.woRoom = woRoom;
    }
}