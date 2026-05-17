using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class TONGDAT_HCTP
    {
        #region Private Member variables  
        private decimal _ID;
        private decimal _DON_ID;
        private string _LOAIVB;
        private string _TENVANBAN;
        private string _SOVB;
        private DateTime? _NGAYVB;
        private string _NGUOIKY;
        private decimal _DONVIPHATHANH_ID;
        private string _DONVIPHATHANH;
        private decimal _TOAANID;
        private DateTime _NGAYTHUHOI;
        private string _LYDOTHUHOI;
        private DateTime _NGAYTAO;
        private string _NGUOITAO;
        private DateTime _NGAYSUA;
        private string _NGUOISUA;
        #endregion

        #region Constructors
        public TONGDAT_HCTP()
        {

        }
        public TONGDAT_HCTP(decimal ID, decimal DON_ID, string LOAIVB, string TENVANBAN, string SOVB, DateTime? NGAYVB, string NGUOIKY, decimal DONVIPHATHANH_ID, string DONVIPHATHANH, decimal TOAANID, DateTime NGAYTHUHOI, string LYDOTHUHOI, DateTime NGAYTAO, string NGUOITAO, DateTime NGAYSUA, string NGUOISUA)
        {
            _ID = ID;
            _DON_ID = DON_ID;
            _LOAIVB = LOAIVB;
            _TENVANBAN = TENVANBAN;
            _SOVB = SOVB;
            _NGAYVB = NGAYVB;
            _NGUOIKY = NGUOIKY;
            _DONVIPHATHANH_ID = DONVIPHATHANH_ID;
            _DONVIPHATHANH = DONVIPHATHANH;
            _TOAANID = TOAANID;
            _NGAYTHUHOI = NGAYTHUHOI;
            _LYDOTHUHOI = LYDOTHUHOI;
            _NGAYTAO = NGAYTAO;
            _NGUOITAO = NGUOITAO;
            _NGAYSUA = NGAYSUA;
            _NGUOISUA = NGUOISUA;
        }
        #endregion

        #region Public properties
        public decimal ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public decimal DON_ID
        {
            get { return _DON_ID; }
            set { _DON_ID = value; }
        }
        public string LOAIVB
        {
            get { return _LOAIVB; }
            set { _LOAIVB = value; }
        }
        public string TENVANBAN
        {
            get { return _TENVANBAN; }
            set { _TENVANBAN = value; }
        }
        public string SOVB
        {
            get { return _SOVB; }
            set { _SOVB = value; }
        }
        public DateTime? NGAYVB
        {
            get { return _NGAYVB; }
            set { _NGAYVB = value; }
        }
        public string NGUOIKY
        {
            get { return _NGUOIKY; }
            set { _NGUOIKY = value; }
        }
        public decimal DONVIPHATHANH_ID
        {
            get { return _DONVIPHATHANH_ID; }
            set { _DONVIPHATHANH_ID = value; }
        }
        public string DONVIPHATHANH
        {
            get { return _DONVIPHATHANH; }
            set { _DONVIPHATHANH = value; }
        }
        public decimal TOAANID
        {
            get { return _TOAANID; }
            set { _TOAANID = value; }
        }
        public DateTime NGAYTHUHOI
        {
            get { return _NGAYTHUHOI; }
            set { _NGAYTHUHOI = value; }
        }
        public string LYDOTHUHOI
        {
            get { return _LYDOTHUHOI; }
            set { _LYDOTHUHOI = value; }
        }
        public DateTime NGAYTAO
        {
            get { return _NGAYTAO; }
            set { _NGAYTAO = value; }
        }
        public string NGUOITAO
        {
            get { return _NGUOITAO; }
            set { _NGUOITAO = value; }
        }
        public DateTime NGAYSUA
        {
            get { return _NGAYSUA; }
            set { _NGAYSUA = value; }
        }
        public string NGUOISUA
        {
            get { return _NGUOISUA; }
            set { _NGUOISUA = value; }
        }
        #endregion
    }
}