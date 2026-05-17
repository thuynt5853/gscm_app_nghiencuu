using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.GSTP
{
    public class RootObject
    {
        public DObject d { get; set; }
    }
    public class DObject
    {
        public List<DataObject> data { get; set; }
    }
    public class DataObject
    {
        public List<Profile> profile { get; set; }
        public List<Training> training { get; set; }
        public List<Family> family { get; set; }
        public List<Working> working { get; set; }
    }
    public class Profile
    {
        public string ORG_NAME { get; set; }
        public string ORG_CHILD_NAME2 { get; set; }
        public string FULLNAME { get; set; }
        public string OTHER_NAME { get; set; }
        public string BIRTH_DAY { get; set; }
        public string BIRTH_MONTH { get; set; }
        public string BIRTH_YEAR { get; set; }
        public string BIRTH_PLACE { get; set; }
        public string GENDER { get; set; }
        public string NAV_ADDRESS { get; set; }
        public string NATIVE_NAME { get; set; }
        public string RELIGION_NAME { get; set; }
        public string PER_ADDRESS { get; set; }
        public string CUR_ADDRESS { get; set; }
        public string JOB_BEFORE { get; set; }
        public string JOIN_DATE { get; set; }
        public string COMPANY_CONG_CHUC { get; set; }
        public string GROUPTITLE_NAME { get; set; }
        public string POS_NAME { get; set; }
        public string RANK_NAME { get; set; }
        public string RANK_CODE { get; set; }
        public string LEVEL_NAME { get; set; }
        public string COEFFICIENT { get; set; }
        public string SALARY_EFFECTDATE { get; set; }
        public string TRINHDOGIAODUC_NAME { get; set; }
        public string TRINHDOCHUYENMON_NAME { get; set; }
        public string LYLUAN_CHINHTRI { get; set; }
        public string QUANLY_NHANUOC { get; set; }
        public string TINHOC { get; set; }
        public string NGOAINGU { get; set; }
        public string NGAYVAODANG { get; set; }
        public string NGAYVAODANG_CHINHTHUC { get; set; }
        public string THAMGIA_TCCT { get; set; }
        public string NGAYNHAPNGU { get; set; }
        public string NGAYXUATNGU { get; set; }
        public string TEN_QUANHAM_CAONHAT { get; set; }
        public string TEN_DANHHIEU_CAONHAT { get; set; }
        public string SOTRUONG_CONGTAC { get; set; }
        public string KHENTHUONG { get; set; }
        public string KYLUAT { get; set; }
        public string TINHTRANGSUCKHOE { get; set; }
        public string CHIEUCAO { get; set; }
        public string CANNANG { get; set; }
        public string NHOMMAU { get; set; }
        public string HANGTHUONGBINH { get; set; }
        public string GIADINHCHINHSACH { get; set; }
        public string CMND { get; set; }
        public string NGAYCAP_CMND { get; set; }
        public string SO_BHXH { get; set; }
        public string ORG_NAME2 { get; set; }
        public string TITLE_NAME { get; set; }
        public string NOW_DAY { get; set; }
        public string NOW_MONTH { get; set; }
        public string NOW_YEAR { get; set; }
        public string THAN_NHAN { get; set; }
        public string TUDAY_TUNGAY { get; set; }
        public string TUDAY_DENNGAY { get; set; }
        public string TUDAY_ODAU { get; set; }
        public string TUDAY_NOIDUNG { get; set; }
        public string TCNN_CONGVIEC { get; set; }
        public string TCNN_TEN { get; set; }
        public string TCNN_TRUSO { get; set; }
        public string IMAGE { get; set; }
        public string ORG_CHILD { get; set; }
        public string ORG_CHILD_NAME { get; set; }
    }
    public class Training
    {
        public string TENTRUONG { get; set; }
        public string NGANHHOC { get; set; }
        public string TUNGAY { get; set; }// MM/yyyy
        public string DENNGAY { get; set; }// MM/yyyy
        public string HINHTHUCDAOTAO { get; set; }
        public string BANGCAP { get; set; }
        public string TEN_BANGCAP { get; set; }
        public string TEN_HINHTHUCDAOTAO { get; set; }
    }
    public class Family
    {
        public string RELATION_NAME { get; set; }
        public string NAME { get; set; }
        public string BIRTH_YEAR { get; set; }
        public string NAV_ADDRESS { get; set; }
        public string JOB { get; set; }
        public string WORK_PLACE { get; set; }
        public string ADDRESS { get; set; }
        //public SYLL_QHGD syll_QHGDs;
    }
    public class Working
    {
        public string EMP { get; set; }
        public string EFFECTDATE { get; set; }
        public string CODE { get; set; }
        public string COEFFICIENT { get; set; }
    }
    public class RootOject_CanBo_KyLuat
    {
        public List<CANBO_KYLUAT> d { get; set; }
    }
    public class CANBO_KYLUAT
    {
        public string Name { get; set; }
        public string REASON { get; set; }
        public string NOTES { get; set; }
        public string DECISION_NO { get; set; }
        public string DECISION_NAME { get; set; }
        public string EFFECTDATE { get; set; }
        public string EXPIREDATE { get; set; }
        public string VIOLATION_DATE { get; set; }
        public string FULLNAME { get; set; }
        public string APPROVE_NAME { get; set; }
        public string POS_APPROVE { get; set; }
        public string SIGNDATE { get; set; }
    }
    public class RootObject_CanBo_KeKhaiTaiSan
    {
        public List<CANBO_KEKHAITAISAN> d { get; set; }
    }
    public class CANBO_KEKHAITAISAN
    {
        public string NHA_GIATRI { get; set; }
        public string NHA_TANGGIAM { get; set; }
        public string NHA_THONGTIN { get; set; }
        public string QSDD_GIATRI { get; set; }
        public string QSDD_TANGGIAM { get; set; }
        public string QSDD_THONGTIN { get; set; }
        public string TSNG_GIATRI { get; set; }
        public string TSND_TANGGIAM { get; set; }
        public string TSNG_THONGTIN { get; set; }
        public string TKNN_GIATRI { get; set; }
        public string TKNN_TANGGIAM { get; set; }
        public string TKNN_THONGTIN { get; set; }
        public string BDTN_GIATRI { get; set; }
        public string BDTN_THONGTIN { get; set; }
        public string BDX_GIATRI { get; set; }
        public string BDX_TANGGIAM { get; set; }
        public string BDX_THONGTIN { get; set; }
        public string BDT_GIATRI { get; set; }
        public string BDT_TANGGIAM { get; set; }
        public string BDT_THONGTIN { get; set; }
        public string BDTSK_GIATRI { get; set; }
        public string BDTSK_TANGGIAM { get; set; }
        public string BDTSK_THONGTIN { get; set; }
    }
    public class RootObject_CanBo_QTDaoTao
    {
        public List<CANBO_QTDAOTAO> d { get; set; }
    }
    public class CANBO_QTDAOTAO
    {
        public string TUTHANG { get; set; }
        public string DENTHANG { get; set; }
        public string TENTRUONG { get; set; }
        public string NGANHHOC { get; set; }
        public string TRINHDO { get; set; }
        public string BANGCAP { get; set; }
        public string XEPLOAI { get; set; }
        public string NAMTOTNGHIEP { get; set; }
        public string NOIDUNGDAOTAO { get; set; }
        public string HINHTHUCDAOTAO { get; set; }
        public string CHUYENMON { get; set; }
    }
}