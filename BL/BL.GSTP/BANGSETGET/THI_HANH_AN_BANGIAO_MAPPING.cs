using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BL.GSTP.BANGSETGET
{
    public class THI_HANH_AN_BANGIAO_MAPPING
    {
        private decimal _ID;
        private decimal? _TOAANGIAOID;
        private string _TOAANGIAOTEN;
        private decimal? _TOAANNHANID;
        private string _TOAANNHANTEN;
        private string _VUVIECID;
        private string _VUVIECLOAI;
        private string _VUVIECMA;
        private string _VUVIECTEN;
        private string _NGUOIGIAOID;
        private string _NGUOIGIAOTEN;
        private string _NGUOINHANID;
        private string _NGUOINHANTEN;
        private string _LYDOMA;
        private DateTime? _NGAYGIAO;
        private DateTime? _NGAYNHAN;
        private decimal? _ISQUYETDINHCHUYEN;
        private string _SOQUYETDINH;
        private DateTime? _NGAYQUYETDINH;
        private string _NGUOIKY;
        private string _TRANGTHAI;
        private string _GHICHU;

        public THI_HANH_AN_BANGIAO_MAPPING()
        {
        }

        public THI_HANH_AN_BANGIAO_MAPPING(decimal ID, decimal? TOAANGIAOID, string TOAANGIAOTEN,
            decimal? TOAANNHANID, string TOAANNHANTEN, string VUVIECID, string VUVIECLOAI,
            string VUVIECMA, string VUVIECTEN, string NGUOIGIAOID,
            string NGUOIGIAOTEN, string NGUOINHANID, string NGUOINHANTEN,
            string LYDOMA, DateTime? NGAYGIAO, DateTime? NGAYNHAN, decimal? ISQUYETDINHCHUYEN,
            string SOQUYETDINH, DateTime? NGAYQUYETDINH, string NGUOIKY, string TRANGTHAI, string GHICHU)
        {
            this.ID = ID;
            this.TOAANGIAOID = TOAANGIAOID;
            this.TOAANGIAOTEN = TOAANGIAOTEN;
            this.TOAANNHANID = TOAANNHANID;
            this.TOAANNHANTEN = TOAANNHANTEN;
            this.VUVIECID = VUVIECID;
            this.VUVIECLOAI = VUVIECLOAI;
            this.VUVIECMA = VUVIECMA;
            this.VUVIECTEN = VUVIECTEN;
            this.NGUOIGIAOID = NGUOIGIAOID;
            this.NGUOIGIAOTEN = NGUOIGIAOTEN;
            this.NGUOINHANID = NGUOINHANID;
            this.NGUOINHANTEN = NGUOINHANTEN;
            this.LYDOMA = LYDOMA;
            this.NGAYGIAO = NGAYGIAO;
            this.NGAYNHAN = NGAYNHAN;
            this.ISQUYETDINHCHUYEN = ISQUYETDINHCHUYEN;
            this.SOQUYETDINH = SOQUYETDINH;
            this.NGAYQUYETDINH = NGAYQUYETDINH;
            this.NGUOIKY = NGUOIKY;
            this.TRANGTHAI = TRANGTHAI;
            this.GHICHU = GHICHU;
        }

        public decimal ID
        {
            get { return _ID; }
            set { _ID = value; }
        }

        public decimal? TOAANGIAOID
        {
            get { return _TOAANGIAOID; }
            set { _TOAANGIAOID = value; }
        }

        public string TOAANGIAOTEN
        {
            get { return _TOAANGIAOTEN; }
            set { _TOAANGIAOTEN = value; }
        }

        public decimal? TOAANNHANID
        {
            get { return _TOAANNHANID; }
            set { _TOAANNHANID = value; }
        }

        public string TOAANNHANTEN
        {
            get { return _TOAANNHANTEN; }
            set { _TOAANNHANTEN = value; }
        }

        public string VUVIECID
        {
            get { return _VUVIECID; }
            set { _VUVIECID = value; }
        }

        public string VUVIECLOAI
        {
            get { return _VUVIECLOAI; }
            set { _VUVIECLOAI = value; }
        }

        public string VUVIECMA
        {
            get { return _VUVIECMA; }
            set { _VUVIECMA = value; }
        }

        public string VUVIECTEN
        {
            get { return _VUVIECTEN; }
            set { _VUVIECTEN = value; }
        }

        public string NGUOIGIAOID
        {
            get { return _NGUOIGIAOID; }
            set { _NGUOIGIAOID = value; }
        }

        public string NGUOIGIAOTEN
        {
            get { return _NGUOIGIAOTEN; }
            set { _NGUOIGIAOTEN = value; }
        }

        public string NGUOINHANID
        {
            get { return _NGUOINHANID; }
            set { _NGUOINHANID = value; }
        }

        public string NGUOINHANTEN
        {
            get { return _NGUOINHANTEN; }
            set { _NGUOINHANTEN = value; }
        }

        public string LYDOMA
        {
            get { return _LYDOMA; }
            set { _LYDOMA = value; }
        }

        public DateTime? NGAYGIAO
        {
            get { return _NGAYGIAO; }
            set { _NGAYGIAO = value; }
        }

        public DateTime? NGAYNHAN
        {
            get { return _NGAYNHAN; }
            set { _NGAYNHAN = value; }
        }

        public decimal? ISQUYETDINHCHUYEN
        {
            get { return _ISQUYETDINHCHUYEN; }
            set { _ISQUYETDINHCHUYEN = value; }
        }

        public string SOQUYETDINH
        {
            get { return _SOQUYETDINH; }
            set { _SOQUYETDINH = value; }
        }

        public DateTime? NGAYQUYETDINH
        {
            get { return _NGAYQUYETDINH; }
            set { _NGAYQUYETDINH = value; }
        }

        public string NGUOIKY
        {
            get { return _NGUOIKY; }
            set { _NGUOIKY = value; }
        }

        public string TRANGTHAI
        {
            get { return _TRANGTHAI; }
            set { _TRANGTHAI = value; }
        }

        public string GHICHU
        {
            get { return _GHICHU; }
            set { _GHICHU = value; }
        }

    }
}
