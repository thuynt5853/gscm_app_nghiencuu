using System;
using System.Collections.Generic;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace BL.GSTP.BANGSETGET
{
    public class GDTTT_GIAIQUYET_TUHINH
    {

        #region Private Member variables 
        private Decimal _LOAI_UP;
        private Decimal _ID;
        private Decimal _VUANID;
        private Decimal _DUONGSU_ID;

        private Decimal _KETLUAN_CA;
        private String _SOQD_CA;
        private DateTime _NGAYQD_CA;
        private String _NOIDUNGQD_CA;

        private String _SOCVGUI_VKS;
        private DateTime _NGAYCVGUI_VKS;
        private DateTime _NGAYCV_PH_VKS;
        private DateTime _NGAYNHANCV_VKS;
        private String _GHICHUCV_GUIVKS;

        private Decimal _KETLUAN_VKS;
        private String _SOQD_VKS;
        private DateTime _NGAYQD_VK;
        private String _SOTT_VKS;
        private DateTime _NGAYTT_VKS;
        private Decimal _NOIDUNGTRINH_VKS;
        private String _GHICHU_VKS_TRA;
 

        private DateTime _CTN_NGAYCHUYEN;
        private Decimal _CTN_NGUOICHUYEN;
        private String _CTN_NGUOINHAN;
        private DateTime _CTN_NGAYNHAN;
        private Decimal _CTN_LOAIQD;
        private String _CTN_SOQD;
        private DateTime _CTN_NGAYQD;
        private DateTime _CTN_NGAYTRA;
        private String _CTN_GHICHU;

        private String _SOCVXM;
        private DateTime _NGAYCVXM;
        private String _NOIDUNGXM;

        private Decimal _LOAIKETQUAXM;
        private DateTime _NGAYKQXM;
        private String _NOIDUNG_KQXM;

        private String _THA_SOCV;
        private DateTime _THA_NGAYCV;
        private DateTime _THA_NGAYPHCV;

        private String _THA_KETQUA;
        private DateTime _THA_NGAY;
        private String _THA_DIADIEM;
        private String _THA_GHICHU;

        private DateTime _LUUHS_NGAYCHUYEN;
        private Decimal _LUUHS_NGUOICHUYEN;
        private DateTime _LUUHS_NGAYNHAN;
        private String _LUUHS_NGUOINHAN;
        private String _LUUHS_DONVINHAN;
        private String _LUUHS_TINHTRANGHS;
        private String _LUUHS_VANBALIENQUAN;
        private DateTime _LUUHS_NGAYTRINHCA;
        private String _LUUHS_GHICHU;
        #endregion
        #region Public properties  
        public Decimal LOAI_UP
        {
            get
            {
                return _LOAI_UP;
            }
            set
            {
                _LOAI_UP = value;
            }
        }
        public Decimal ID
        {
            get
            {
                return _ID;
            }
            set
            {
                _ID = value;
            }
        }
        public Decimal VUANID
        {
            get
            {
                return  _VUANID;
            }
            set
            {
                _VUANID = value;
            }

        }

        public Decimal DUONGSU_ID
        {
            get
            {
                return _DUONGSU_ID;
            }
            set
            {
                _DUONGSU_ID = value;
            }

        }
        

        // KET QUA CHANH AN
        public Decimal KELUAN_CA
        {
            get
            {
                return _KETLUAN_CA;
            }
            set
            {
                _KETLUAN_CA = value;
            }

        }
       
        public String SOQD_CA
        {
            get
            {
                return _SOQD_CA;
            }
            set
            {
                _SOQD_CA = value;
            }
        }

        public DateTime NGAYQD_CA
        {
            get
            {
                return _NGAYQD_CA;
            }
            set
            {
                _NGAYQD_CA = value;
            }

        }
        
        public String NOIDUNGQD_CA
        {
            get
            {
                return _NOIDUNGQD_CA;
            }
            set
            {
                _NOIDUNGQD_CA = value;
            }
        }

        public String SOCVGUI_VKS
        {
            get
            {
                return _SOCVGUI_VKS;
            }
            set
            {
                _SOCVGUI_VKS = value;
            }

        }

        public DateTime NGAYCVGUI_VKS
        {
            get
            {
                return _NGAYCVGUI_VKS;
            }
            set
            {
                _NGAYCVGUI_VKS = value;
            }

        }

        public DateTime NGAYCV_PH_VKS
        {
            get
            {
                return _NGAYCV_PH_VKS;
            }
            set
            {
                _NGAYCV_PH_VKS = value;
            }

        }

        public String GHICHUCV_GUIVKS
        {
            get
            {
                return _GHICHUCV_GUIVKS;
            }
            set
            {
                _GHICHUCV_GUIVKS = value;
            }

        }
        // KET QUA VKS
        public DateTime NGAYNHANCV_VKS
        {
            get
            {
                return _NGAYNHANCV_VKS;
            }
            set
            {
                _NGAYNHANCV_VKS = value;
            }

        }

        public String SOQD_VKS
        {
            get
            {
                return _SOQD_VKS;
            }
            set
            {
                _SOQD_VKS = value;
            }

        }

        public DateTime NGAYQD_VK
        {
            get
            {
                return _NGAYQD_VK;
            }
            set
            {
                _NGAYQD_VK = value;
            }

        }

        public Decimal KETLUAN_VKS
        {
            get
            {
                return _KETLUAN_VKS;
            }
            set
            {
                _KETLUAN_VKS = value;
            }

        }
        // VKS TRA KET QUA
        public DateTime NGAYTT_VKS
        {
            get
            {
                return _NGAYTT_VKS;
            }
            set
            {
                _NGAYTT_VKS = value;
            }

        }

        public String SOTT_VKS
        {
            get
            {
                return _SOTT_VKS;
            }
            set
            {
                _SOTT_VKS = value;
            }
        }

        public Decimal NOIDUNGTRINH_VKS
        {
            get
            {
                return _NOIDUNGTRINH_VKS;
            }
            set
            {
                _NOIDUNGTRINH_VKS = value;
            }

        }

        public String GHICHU_VKS_TRA
        {
            get
            {
                return _GHICHU_VKS_TRA;
            }
            set
            {
                _GHICHU_VKS_TRA = value;
            }
        }


        //-- CHUYEN VAN PHONG CHU TICH NUOC---

        public DateTime  CTN_NGAYCHUYEN
        {
            get
            {
                return _CTN_NGAYCHUYEN;
            }
            set
            {
                _CTN_NGAYCHUYEN = value;
            }

        }

        public Decimal CTN_NGUOCHUYEN
        {
            get
            {
                return _CTN_NGUOICHUYEN;
            }
            set
            {
                _CTN_NGUOICHUYEN = value;
            }

        }

        public String CTN_NGUOINHAN
        {
            get
            {
                return _CTN_NGUOINHAN;
            }
            set
            {
                _CTN_NGUOINHAN = value;
            }

        }

        public DateTime CTN_NGAYNHAN
        {
            get
            {
                return _CTN_NGAYNHAN;
            }
            set
            {
                _CTN_NGAYNHAN = value;
            }

        }

        public String CTN_SOQD
        {
            get
            {
                return _CTN_SOQD;
            }
            set
            {
                _CTN_SOQD = value;
            }

        }

        public DateTime CTN_NGAYQD
        {
            get
            {
                return _CTN_NGAYQD;
            }
            set
            {
                _CTN_NGAYQD = value;
            }

        }


        public Decimal CTN_LOAIQD
        {
            get
            {
                return _CTN_LOAIQD;
            }
            set
            {
                _CTN_LOAIQD = value;
            }

        }

        public DateTime CTN_NGAYTRA
        {
            get
            {
                return _CTN_NGAYTRA;
            }
            set
            {
                _CTN_NGAYTRA = value;
            }

        }

        public String CTN_GHICHU
        {
            get
            {
                return _CTN_GHICHU;
            }
            set
            {
                _CTN_GHICHU = value;
            }
        }
        // -- CONG VAN XAC MINH
        public String SOCVXM
        {
            get
            {
                return _SOCVXM;
            }
            set
            {
                _SOCVXM = value;
            }
        }
        public DateTime NGAYCVXM
        {
            get
            {
                return _NGAYCVXM;
            }
            set
            {
                _NGAYCVXM = value;
            }

        }
        public String NOIDUNGXM
        {
            get
            {
                return _NOIDUNGXM;
            }
            set
            {
                _NOIDUNGXM = value;
            }
        }
        public Decimal LOAIKETQUAXM
        {
            get
            {
                return _LOAIKETQUAXM;
            }
            set
            {
                _LOAIKETQUAXM = value;
            }
        }
        public DateTime NGAYKQXM
        {
            get
            {
                return _NGAYKQXM;
            }
            set
            {
                _NGAYKQXM = value;
            }
        }
        public String NOIDUNG_KQXM
        {
            get
            {
                return _NOIDUNG_KQXM;
            }
            set
            {
                _NOIDUNG_KQXM = value;
            }

        }
        // -- THI HANH AN

      

        public String THA_SOCV
        {
            get
            {
                return _THA_SOCV;
            }
            set
            {
                _THA_SOCV = value;
            }

        }

        public DateTime THA_NGAYCV
        {
            get
            {
                return _THA_NGAYCV;
            }
            set
            {
                _THA_NGAYCV = value;
            }

        }

        public DateTime THA_NGAYPHCV
        {
            get
            {
                return _THA_NGAYPHCV;
            }
            set
            {
                _THA_NGAYPHCV = value;
            }

        }

        public String THA_KETQUA
        {
            get
            {
                return _THA_KETQUA;
            }
            set
            {
                _THA_KETQUA = value;
            }

        }

        public DateTime THA_NGAY
        {
            get
            {
                return _THA_NGAY;
            }
            set
            {
                _THA_NGAY = value;
            }

        }

        public String THA_DIADIEM
        {
            get
            {
                return _THA_DIADIEM;
            }
            set
            {
                _THA_DIADIEM = value;
            }

        }
        public String THA_GHICHU
        {
            get
            {
                return _THA_GHICHU;
            }
            set
            {
                _THA_GHICHU = value;
            }

        }


        //-- LUU HO SO---
        public DateTime LUUHS_NGAYCHUYEN
        {
            get
            {
                return _LUUHS_NGAYCHUYEN;
            }
            set
            {
                _LUUHS_NGAYCHUYEN = value;
            }

        }
        public Decimal LUUHS_NGUOICHUYEN
        {
            get
            {
                return _LUUHS_NGUOICHUYEN;
            }
            set
            {
                _LUUHS_NGUOICHUYEN = value;
            }

        }

        public DateTime LUUHS_NGAYNHAN
        {
            get
            {
                return _LUUHS_NGAYNHAN;
            }
            set
            {
                _LUUHS_NGAYNHAN = value;
            }

        }

        public String LUUHS_NGUOINHAN
        {
            get
            {
                return _LUUHS_NGUOINHAN;
            }
            set
            {
                _LUUHS_NGUOINHAN = value;
            }

        }
        public String LUUHS_DONVINHAN
        {
            get
            {
                return _LUUHS_DONVINHAN;
            }
            set
            {
                _LUUHS_DONVINHAN = value;
            }

        }
        public String LUUHS_TINHTRANGHS
        {
            get
            {
                return _LUUHS_TINHTRANGHS;
            }
            set
            {
                _LUUHS_TINHTRANGHS = value;
            }

        }
        public String LUUHS_VANBALIENQUAN
        {
            get
            {
                return _LUUHS_VANBALIENQUAN;
            }
            set
            {
                _LUUHS_VANBALIENQUAN = value;
            }

        }
        public DateTime LUUHS_NGAYTRINHCA
        {
            get
            {
                return _LUUHS_NGAYTRINHCA;
            }
            set
            {
                _LUUHS_NGAYTRINHCA = value;
            }

        }
        public String LUUHS_GHICHU
        {
            get
            {
                return _LUUHS_GHICHU;
            }
            set
            {
                _LUUHS_GHICHU = value;
            }
        }
      
        #endregion
        #region Constructors
        public GDTTT_GIAIQUYET_TUHINH()
        {

        }
        public GDTTT_GIAIQUYET_TUHINH(Decimal LOAI_UP, Decimal ID, Decimal VUANID, Decimal DUONGSU_ID, Decimal KETLUAN_CA, String SOQD_CA, DateTime NGAYQD_CA, String NOIDUNGQD_CA, String SOCVGUI_VKS,
        DateTime NGAYCVGUI_VKS, DateTime NGAYCV_PH_VKS,DateTime NGAYNHANCV_VKS, String GHICHUCV_GUIVKS,Decimal KETLUAN_VKS, String SOQD_VKS, DateTime NGAYQD_VK, String SOTT_VKS, DateTime NGAYTT_VKS,
        Decimal NOIDUNGTRINH_VKS, String GHICHU_VKS_TRA, DateTime CTN_NGAYCHUYEN, Decimal CTN_NGUOICHUYEN, String CTN_NGUOINHAN, DateTime CTN_NGAYNHAN, Decimal CTN_LOAIQD,
        String CTN_SOQD, DateTime CTN_NGAYQD, DateTime CTN_NGAYTRA,String CTN_GHICHU, String SOCVXM,DateTime NGAYCVXM, String NOIDUNGXM, Decimal LOAIKETQUAXM,DateTime NGAYKQXM, String NOIDUNG_KQXM, 
        String THA_SOCV,DateTime THA_NGAYCV, DateTime THA_NGAYPHCV,String THA_KETQUA, DateTime THA_NGAY,
        String THA_DIADIEM,String THA_GHICHU, DateTime LUUHS_NGAYCHUYEN, Decimal LUUHS_NGUOICHUYEN, DateTime LUUHS_NGAYNHAN, String LUUHS_NGUOINHAN, String LUUHS_DONVINHAN, String LUUHS_TINHTRANGHS,
        String LUUHS_VANBALIENQUAN, DateTime LUUHS_NGAYTRINHCA, String LUUHS_GHICHU)
        {
            _LOAI_UP = LOAI_UP;
            _ID = ID;
            _VUANID = VUANID;
            _DUONGSU_ID = DUONGSU_ID;

            _KETLUAN_CA = KETLUAN_CA;
            _SOQD_CA = SOQD_CA;
            _NGAYQD_CA = NGAYQD_CA;
            _NOIDUNGQD_CA = NOIDUNGQD_CA;

            _SOCVGUI_VKS = SOCVGUI_VKS;
            _NGAYCVGUI_VKS = NGAYCVGUI_VKS;
            _NGAYCV_PH_VKS = NGAYCV_PH_VKS;
            _NGAYNHANCV_VKS = NGAYNHANCV_VKS;
            _GHICHUCV_GUIVKS = GHICHUCV_GUIVKS;

            _KETLUAN_VKS = KETLUAN_VKS;
            _SOQD_VKS = SOQD_VKS;
            _NGAYQD_VK = NGAYQD_VK;
            _SOTT_VKS = SOTT_VKS;
            _NGAYTT_VKS = NGAYTT_VKS;
            _NOIDUNGTRINH_VKS = NOIDUNGTRINH_VKS;
            _GHICHU_VKS_TRA = GHICHU_VKS_TRA;
           

            _CTN_NGAYCHUYEN = CTN_NGAYCHUYEN;
            _CTN_NGUOICHUYEN = CTN_NGUOICHUYEN;
            _CTN_NGUOINHAN  = CTN_NGUOINHAN;
            _CTN_NGAYNHAN   = CTN_NGAYNHAN;
            _CTN_LOAIQD = CTN_LOAIQD;
            _CTN_SOQD = CTN_SOQD;
            _CTN_NGAYQD = CTN_NGAYQD;
            _CTN_NGAYTRA = CTN_NGAYTRA;
            _CTN_GHICHU = CTN_GHICHU;

            _SOCVXM = SOCVXM;
            _NGAYCVXM = NGAYCVXM;
            _NOIDUNGXM = NOIDUNGXM;

            _LOAIKETQUAXM = LOAIKETQUAXM;
            _NGAYKQXM = NGAYKQXM;
            _NOIDUNG_KQXM = NOIDUNG_KQXM;
           
            //-----
            _THA_SOCV = THA_SOCV;
            _THA_NGAYCV = THA_NGAYCV;
            _THA_NGAYPHCV = THA_NGAYPHCV;

            _THA_KETQUA = THA_KETQUA;
            _THA_NGAY = THA_NGAY;
            _THA_DIADIEM = THA_DIADIEM;
            _THA_GHICHU = THA_GHICHU;

            _LUUHS_NGAYCHUYEN = LUUHS_NGAYCHUYEN;
            _LUUHS_NGUOICHUYEN = LUUHS_NGUOICHUYEN;
            _LUUHS_NGAYNHAN = LUUHS_NGAYNHAN;
            _LUUHS_NGUOINHAN = LUUHS_NGUOINHAN;
            _LUUHS_DONVINHAN = LUUHS_DONVINHAN;
            _LUUHS_TINHTRANGHS = LUUHS_TINHTRANGHS;
            _LUUHS_VANBALIENQUAN = LUUHS_VANBALIENQUAN;
            _LUUHS_NGAYTRINHCA = LUUHS_NGAYTRINHCA;
            _LUUHS_GHICHU = LUUHS_GHICHU;
    }
        #endregion
    }
}