using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.BANGSETGET
{
    public class DM_HINHTHUCGUI
    {
        #region Private Member variables  
        private decimal _ID;
        private string _TEN_HINHTHUCGUI;
        private decimal _HIEULUC;
        private decimal _CO_GUI_VBDH;
        private DateTime _NGAYTAO;
        private string _NGUOITAO;
        private decimal _GIATRI;
        #endregion

        #region Constructors
        public DM_HINHTHUCGUI()
        {

        }
        public DM_HINHTHUCGUI(decimal ID, string TEN_HINHTHUCGUI, decimal HIEULUC, decimal CO_GUI_VBDH, DateTime NGAYTAO, string NGUOITAO, decimal GIATRI)
        {
            _ID = ID;
            _TEN_HINHTHUCGUI = TEN_HINHTHUCGUI;
            _HIEULUC = HIEULUC;
            _CO_GUI_VBDH = CO_GUI_VBDH;
            _NGAYTAO = NGAYTAO;
            _NGUOITAO = NGUOITAO;
            _GIATRI = GIATRI;
        }
        #endregion

        #region Public properties
        public decimal ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public string TEN_HINHTHUCGUI
        {
            get { return _TEN_HINHTHUCGUI; }
            set { _TEN_HINHTHUCGUI = value; }
        }
        public decimal HIEULUC
        {
            get { return _HIEULUC; }
            set { _HIEULUC = value; }
        }
        public decimal CO_GUI_VBDH
        {
            get { return _CO_GUI_VBDH; }
            set { _CO_GUI_VBDH = value; }
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
        public decimal GIATRI
        {
            get { return _GIATRI; }
            set { _GIATRI = value; }
        }
        #endregion
    }
}