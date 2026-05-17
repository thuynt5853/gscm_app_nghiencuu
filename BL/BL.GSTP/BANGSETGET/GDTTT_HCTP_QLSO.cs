using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class GDTTT_HCTP_QLSO
    {
        #region Private Member variables
        private decimal _ID;
        private string _SO;
        private DateTime _NGAY;
        private string _NGUOIKY;
        private decimal _DONID;
        private string _SO_TT;
        private DateTime? _NGAY_TT;
        private decimal _LOAI;
        private DateTime _NGAYTAO;
        private string _NGUOITAO;
        private DateTime _NGAYSUA;
        private string _NGUOISUA;
        #endregion

        #region Constructors
        public GDTTT_HCTP_QLSO()
        {

        }
        public GDTTT_HCTP_QLSO(decimal ID, string SO, DateTime NGAY, string NGUOIKY, decimal DONID, string SOTT, DateTime? NGAYTT, decimal LOAI, DateTime NGAYTAO, string NGUOITAO, DateTime NGAYSUA, string NGUOISUA)
        {
            _ID = ID;
            _SO = SO;
            _NGAY = NGAY;
            _NGUOIKY = NGUOIKY;
            _DONID = DONID;
            _SO_TT = _SO_TT;
            _NGAY_TT = _NGAY_TT;
            _LOAI = LOAI;
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
        public string SO
        {
            get { return _SO; }
            set { _SO = value; }
        }
        public DateTime NGAY
        {
            get { return _NGAY; }
            set { _NGAY = value; }
        }
        public string NGUOIKY
        {
            get { return _NGUOIKY; }
            set { _NGUOIKY = value; }
        }
        public decimal DONID
        {
            get { return _DONID; }
            set { _DONID = value; }
        }
        public string SO_TT
        {
            get { return _SO_TT; }
            set { _SO_TT = value; }
        }
        public DateTime? NGAY_TT
        {
            get { return _NGAY_TT; }
            set { _NGAY_TT = value; }
        }
        public decimal LOAI
        {
            get { return _LOAI; }
            set { _LOAI = value; }
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