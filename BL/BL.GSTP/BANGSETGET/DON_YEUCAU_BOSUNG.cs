using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class DON_YEUCAU_BOSUNG
    {
        private decimal _ID;
        private decimal? _DONID;
        private decimal _LOAIAN;
        private decimal? _DON_XULYID;
        private decimal? _LOAIGIAIQUYET;
        private DateTime? _NGAYGQ_YC;
        private string _LYDO;
        private decimal? _CDTN_TOAANID;
        private DateTime? _CDTN_NGAYNHAN;
        private string _CDNN_TENCQ;
        private decimal? _TRADON_CANCUID;
        private DateTime? _NGAYTAO;
        private string _NGUOITAO;
        private DateTime? _NGAYSUA;
        private string _NGUOISUA;
        private DateTime? _CDNN_NGAYCHUYEN;
        private decimal? _TRADON_LYDOID;
        private DateTime? _TRADON_NGAYTRA;
        private DateTime? _YCBS_NGAYYEUCAU;
        private string _YCBS_NOIDUNG;
        private DateTime? _CDTN_NGAYCHUYEN;
        private string _SOTHONGBAO;
        private decimal? _FILEID;
        private decimal? _YCBS_THOIHAN;
        private decimal? _TOAANID;
        private DateTime? _NGAYTHONGBAO;
        private decimal? _DON_CHITIETID;
        private string _SOHIEU;
        private DateTime _NGAYBOSUNG;
        private decimal? _DON_XULY_YCBS_ID;
        private string _STB_PHU;

        public DON_YEUCAU_BOSUNG()
        {

        }

        public DON_YEUCAU_BOSUNG(decimal ID, decimal DONID, decimal LOAIAN, decimal DON_XULYID, decimal LOAIGIAIQUYET, DateTime NGAYGQ_YC, string LYDO, decimal CDTN_TOAANID, DateTime CDTN_NGAYNHAN, string CDNN_TENCQ, decimal TRADON_CANCUID, DateTime NGAYTAO, string NGUOITAO, DateTime NGAYSUA, string NGUOISUA, DateTime CDNN_NGAYCHUYEN, decimal TRADON_LYDOID, DateTime TRADON_NGAYTRA, DateTime YCBS_NGAYYEUCAU, string YCBS_NOIDUNG, DateTime CDTN_NGAYCHUYEN, string SOTHONGBAO, decimal FILEID, decimal YCBS_THOIHAN, decimal TOAANID, DateTime NGAYTHONGBAO, decimal DON_CHITIETID, string SOHIEU, DateTime NGAYBOSUNG, decimal DON_XULY_YCBS_ID, string STB_PHU)
        {
            this.ID = ID;
            this.DONID = DONID;
            this.LOAIAN = LOAIAN;
            this.DON_XULYID = DON_XULYID;
            this.LOAIGIAIQUYET = LOAIGIAIQUYET;
            this.NGAYGQ_YC = NGAYGQ_YC;
            this.LYDO = LYDO;
            this.CDTN_TOAANID = CDTN_TOAANID;
            this.CDTN_NGAYNHAN = CDTN_NGAYNHAN;
            this.CDNN_TENCQ = CDNN_TENCQ;
            this.TRADON_CANCUID = TRADON_CANCUID;
            this.NGAYTAO = NGAYTAO;
            this.NGUOITAO = NGUOITAO;
            this.NGAYSUA = NGAYSUA;
            this.NGUOISUA = NGUOISUA;
            this.CDNN_NGAYCHUYEN = CDNN_NGAYCHUYEN;
            this.TRADON_LYDOID = TRADON_LYDOID;
            this.TRADON_NGAYTRA = TRADON_NGAYTRA;
            this.YCBS_NGAYYEUCAU = YCBS_NGAYYEUCAU;
            this.YCBS_NOIDUNG = YCBS_NOIDUNG;
            this.CDTN_NGAYCHUYEN = CDTN_NGAYCHUYEN;
            this.SOTHONGBAO = SOTHONGBAO;
            this.FILEID = FILEID;
            this.YCBS_THOIHAN = YCBS_THOIHAN;
            this.TOAANID = TOAANID;
            this.NGAYTHONGBAO = NGAYTHONGBAO;
            this.DON_CHITIETID = DON_CHITIETID;
            this.SOHIEU = SOHIEU;
            this.NGAYBOSUNG = NGAYBOSUNG;
            this.DON_XULY_YCBS_ID = DON_XULY_YCBS_ID;
            this.STB_PHU = STB_PHU;
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
        public Decimal? DONID
        {
            get
            {
                return _DONID;
            }
            set
            {
                _DONID = value;
            }
        }
        public Decimal LOAIAN
        {
            get
            {
                return _LOAIAN;
            }
            set
            {
                _LOAIAN = value;
            }
        }
        public Decimal? DON_XULYID
        {
            get
            {
                return _DON_XULYID;
            }
            set
            {
                _DON_XULYID = value;
            }
        }
        public Decimal? LOAIGIAIQUYET
        {
            get
            {
                return _LOAIGIAIQUYET;
            }
            set
            {
                _LOAIGIAIQUYET = value;
            }
        }
        public DateTime? NGAYGQ_YC
        {
            get
            {
                return _NGAYGQ_YC;
            }
            set
            {
                _NGAYGQ_YC = value;
            }
        }
        public String LYDO
        {
            get
            {
                return _LYDO;
            }
            set
            {
                _LYDO = value;
            }
        }
        public Decimal? CDTN_TOAANID
        {
            get
            {
                return _CDTN_TOAANID;
            }
            set
            {
                _CDTN_TOAANID = value;
            }
        }
        public DateTime? CDTN_NGAYNHAN
        {
            get
            {
                return _CDTN_NGAYNHAN;
            }
            set
            {
                _CDTN_NGAYNHAN = value;
            }
        }
        public string CDNN_TENCQ
        {
            get
            {
                return _CDNN_TENCQ;
            }
            set
            {
                _CDNN_TENCQ = value;
            }
        }
        public Decimal? TRADON_CANCUID
        {
            get
            {
                return _TRADON_CANCUID;
            }
            set
            {
                _TRADON_CANCUID = value;
            }
        }
        public DateTime? NGAYTAO
        {
            get
            {
                return _NGAYTAO;
            }
            set
            {
                _NGAYTAO = value;
            }
        }
        public string NGUOITAO
        {
            get
            {
                return _NGUOITAO;
            }
            set
            {
                _NGUOITAO = value;
            }
        }
        public DateTime? NGAYSUA
        {
            get
            {
                return _NGAYSUA;
            }
            set
            {
                _NGAYSUA = value;
            }
        }
        public string NGUOISUA
        {
            get
            {
                return _NGUOISUA;
            }
            set
            {
                _NGUOISUA = value;
            }
        }
        public DateTime? CDNN_NGAYCHUYEN
        {
            get
            {
                return _CDNN_NGAYCHUYEN;
            }
            set
            {
                _CDNN_NGAYCHUYEN = value;
            }
        }
        public Decimal? TRADON_LYDOID
        {
            get
            {
                return _TRADON_LYDOID;
            }
            set
            {
                _TRADON_LYDOID = value;
            }
        }
        public DateTime? TRADON_NGAYTRA
        {
            get
            {
                return _TRADON_NGAYTRA;
            }
            set
            {
                _TRADON_NGAYTRA = value;
            }
        }
        public DateTime? YCBS_NGAYYEUCAU
        {
            get
            {
                return _YCBS_NGAYYEUCAU;
            }
            set
            {
                _YCBS_NGAYYEUCAU = value;
            }
        }
        public String YCBS_NOIDUNG
        {
            get
            {
                return _YCBS_NOIDUNG;
            }
            set
            {
                _YCBS_NOIDUNG = value;
            }
        }
        public DateTime? CDTN_NGAYCHUYEN
        {
            get
            {
                return _CDTN_NGAYCHUYEN;
            }
            set
            {
                _CDTN_NGAYCHUYEN = value;
            }
        }
        public String SOTHONGBAO
        {
            get
            {
                return _SOTHONGBAO;
            }
            set
            {
                _SOTHONGBAO = value;
            }
        }
        public Decimal? FILEID
        {
            get
            {
                return _FILEID;
            }
            set
            {
                _FILEID = value;
            }
        }
        public Decimal? YCBS_THOIHAN
        {
            get
            {
                return _YCBS_THOIHAN;
            }
            set
            {
                _YCBS_THOIHAN = value;
            }
        }
        public Decimal? TOAANID
        {
            get
            {
                return _TOAANID;
            }
            set
            {
                _TOAANID = value;
            }
        }
        public DateTime? NGAYTHONGBAO
        {
            get
            {
                return _NGAYTHONGBAO;
            }
            set
            {
                _NGAYTHONGBAO = value;
            }
        }
        public Decimal? DON_CHITIETID
        {
            get
            {
                return _DON_CHITIETID;
            }
            set
            {
                _DON_CHITIETID = value;
            }
        }
        public DateTime NGAYBOSUNG
        {
            get
            {
                return _NGAYBOSUNG;
            }
            set
            {
                _NGAYBOSUNG = value;
            }
        }
        public String SOHIEU
        {
            get
            {
                return _SOHIEU;
            }
            set
            {
                _SOHIEU = value;
            }
        }
        public Decimal? DON_XULY_YCBS_ID
        {
            get
            {
                return _DON_XULY_YCBS_ID;
            }
            set
            {
                _DON_XULY_YCBS_ID = value;
            }
        }
        public String STB_PHU
        {
            get
            {
                return _STB_PHU;
            }
            set
            {
                _STB_PHU = value;
            }
        }
    }
}