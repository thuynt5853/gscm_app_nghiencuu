using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class Thongtinvuan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        String SessionTTV = "GDTTT_TTV";
        public decimal VuAnID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            VuAnID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    chkModify_LanhDao.Visible = chkModify_TP.Visible = chkModify_TTV.Visible = false;
                    LoadComponent();
                    if (Request["ID"] != null)
                    {
                        hddID.Value = Request["ID"] + "";
                        try
                        {
                            LoadInfoVuAn();
                        }
                        catch (Exception ex) { }


                        if (ddlLoaiBA.SelectedValue == "1")
                        {
                            LoadDropToaST_Full_ST();//anhvh 14/11/2019
                        }
                    }
                    else
                    {
                        DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                        rptNguyenDon.DataSource = tbl;
                        rptNguyenDon.DataBind();

                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                        rptBiDon.DataSource = tbl;
                        rptBiDon.DataBind();

                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                        rptDsKhac.DataSource = tbl;
                        rptDsKhac.DataBind();
                    }
                    if (Request["type"] != null)
                    {
                        if (Request["type"].ToString() == "renew")
                        {
                            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
                            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công! Bạn có thể tiếp tục cập nhật vụ án mới";
                        }
                    }
                    txtSoThuLy.Focus();
                    CheckCongbo();
                }
            }
            else Response.Redirect("/Login.aspx");
        }

        //-------------------------------------------
        void LoadComponent()
        {
            LoadDropToaAnGDT(dropToaGDT);
            LoadDropToaAn();
            LoadLoaiAnTheoVu();
            LoadDMQuanHePL();

            try
            {
                LoadDropLanhDao();
                LoadDropTTV();
                LoadThamPhan();
            }
            catch (Exception ex) { }
            LoadQHPLTK();
            hddGUID.Value = Guid.NewGuid().ToString();
            //---------------
            if (dropLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                pnBiDon.Visible = false;
        }
        private void LoadQHPLTK()
        {
            dropQHPLThongKe.Items.Clear();
            string strLoaiAn = dropLoaiAn.SelectedValue;

            if (strLoaiAn == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                dropQHPLThongKe.DataSource = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == 5 && x.LOAI == 2).OrderBy(x => x.TENTOIDANH).ToList();
                dropQHPLThongKe.DataTextField = "TENTOIDANH";
                dropQHPLThongKe.DataValueField = "ID";
                dropQHPLThongKe.DataBind();
                dropQHPLThongKe.Items.Insert(0, new ListItem("Chọn", "0"));
                return;
            }
            List<DM_QHPL_TK> lstDM = null;
            switch (strLoaiAn)
            {
                case ENUM_LOAIVUVIEC.AN_DANSU:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_LAODONG:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.LAODONG && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_PHASAN:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
            }
            dropQHPLThongKe.DataSource = lstDM;
            dropQHPLThongKe.DataTextField = "CASE_NAME";
            dropQHPLThongKe.DataValueField = "ID";
            dropQHPLThongKe.DataBind();
            dropQHPLThongKe.Items.Insert(0, new ListItem("Chọn", "0"));
        }

        void LoadDropToaAn()
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));

        }
        void LoadDropToaAnGDT_ALL()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);// oTABL.DM_TOAAN_GETBY(1);
            dropToaGDT.DataSource = dtTA;
            dropToaGDT.DataTextField = "TEN";
            dropToaGDT.DataValueField = "ID";
            dropToaGDT.DataBind();
            dropToaGDT.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaAnGDT(DropDownList dropToaGDT)
        {
            dropToaGDT.Items.Clear();
            List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.CAPCHAID < 2 && x.HANHCHINHID != 0).OrderBy(y => y.CAPCHAID).ToList();
            dropToaGDT.DataSource = lst;
            dropToaGDT.DataTextField = "TEN";
            dropToaGDT.DataValueField = "ID";
            dropToaGDT.DataBind();
            dropToaGDT.Items.Insert(0, new ListItem("Chọn", "0"));
        }



        void LoadDropToaPT_TheoGDT(decimal ToaGDT_ID)
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            //Decimal CapChaID = Convert.ToDecimal(dropToaGDT.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(ToaGDT_ID);
            dropToaAn.DataSource = tbl;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
        }

        void LoadDropToaST_TheoPT(decimal ToaPT_ID)
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            //Decimal CapChaID = Convert.ToDecimal(dropToaAn.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(ToaPT_ID);
            dropToaAnST.DataSource = tbl;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaST_Full_ST()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR_ST();
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        //thoing nx 09102019
        void LoadDropToaST_Full()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadLoaiAnTheoVu()
        {
            int count_loaian = 0;
            dropLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj.ISHINHSU == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                count_loaian++;
            }
            if (obj.ISDANSU == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                count_loaian++;
            }
            if (obj.ISHANHCHINH == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                count_loaian++;
            }
            if (obj.ISHNGD == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                count_loaian++;
            }
            if (obj.ISKDTM == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                count_loaian++;
            }
            if (obj.ISLAODONG == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                count_loaian++;
            }
            if (obj.ISPHASAN == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                count_loaian++;
            }
            if (count_loaian > 1)
                dropLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        //---------------------------
        protected void dropLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDMQuanHePL();
            LoadQHPLTK();

            SetControl_AnHinhSu();
            Cls_Comon.SetFocus(this, this.GetType(), dropQHPL.ClientID);
        }

        void SetControl_AnHinhSu()
        {
            if (dropLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                pnNguyenDon.Visible = false;
            }
        }
        void LoadDMQuanHePL()
        {
            try
            {
                int LoaiAn = Convert.ToInt16(dropLoaiAn.SelectedValue);
                List<GDTTT_DM_QHPL> lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == LoaiAn).OrderBy(y => y.TENQHPL).ToList();
                if (lst != null && lst.Count > 0)
                {
                    dropQHPL.Items.Clear();
                    dropQHPL.DataSource = lst;
                    dropQHPL.DataTextField = "TenQHPL";
                    dropQHPL.DataValueField = "ID";
                    dropQHPL.DataBind();
                    dropQHPL.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
            catch (Exception ex) { }
        }
        //Tòa GDT
        protected void dropToaGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            hddInputAnST.Value = "0";
            decimal toa_an_id = Convert.ToDecimal(dropToaGDT.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)//&& (obj.LOAITOA == "CAPCAO" || obj.LOAITOA == "CAPTINH"))
                {
                    pnPhucTham.Visible = true;
                    pnAnST.Visible = true;
                    hddInputAnST.Value = "1";
                    Cls_Comon.SetFocus(this, this.GetType(), lttBB_SoPT.ClientID);
                    LoadDropToaPT_TheoGDT(Convert.ToDecimal(toa_an_id));
                }
                else { dropToaAn.Items.Clear(); }
                string banan_gdt = txtSoQĐGDT.Text.Trim();
                if (!string.IsNullOrEmpty(banan_gdt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoQĐGDT.ClientID);
            }
            else
            {
                pnQDGDT.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaGDT.ClientID);
                dropToaGDT.Items.Clear();
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
                dropToaAnST.Items.Clear();
            }
        }
        //-----------------------
        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            hddInputAnST.Value = "0";
            decimal toa_an_id = Convert.ToDecimal(dropToaAn.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)//&& (obj.LOAITOA == "CAPCAO" || obj.LOAITOA == "CAPTINH"))
                {
                    pnAnST.Visible = true;
                    hddInputAnST.Value = "1";
                    Cls_Comon.SetFocus(this, this.GetType(), txtSoBA_ST.ClientID);
                    LoadDropToaST_TheoPT(toa_an_id);
                }
                else { dropToaAnST.Items.Clear(); }
                string banan_pt = txtSoBA.Text.Trim();
                if (!string.IsNullOrEmpty(banan_pt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoBA.ClientID);
            }
            else
            {
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
                dropToaAnST.Items.Clear();
            }
        }
        protected void ddlLoaiBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiBA.SelectedValue == "3")
            {
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
                pnQDGDT.Visible = false;
                hddIsAnPT.Value = "PT";
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
            }
            else if (ddlLoaiBA.SelectedValue == "2")//anhvh 14/11/2019
            {
                hddIsAnPT.Value = "ST";
                pnQDGDT.Visible = false;
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaST_Full_ST();
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;

            }
            else if (ddlLoaiBA.SelectedValue == "4")
            {
                pnQDGDT.Visible = true;
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
                hddIsAnPT.Value = "GDT";
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                LoadDropToaST_Full_ST();
            }
            else
            {
                hddIsAnPT.Value = "PT";
                pnQDGDT.Visible = false;
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaST_Full();
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
            }
            //if (ddlLoaiBA.SelectedValue == "1")//anhvh 14/11/2019
            //{

            //    pnPhucTham.Visible = false;
            //    pnAnST.Visible = true;
            //    LoadDropToaST_Full_ST();
            //}
            //else
            //{
            //    pnPhucTham.Visible = false;
            //    pnAnST.Visible = true;
            //    LoadDropToaST_Full();
            //}
        }

        //--------------------------------
        void LoadDropLanhDao()
        {
            dropLanhDao.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DataTable tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count > 0)
            {
                dropLanhDao.DataSource = tblLanhDao;
                dropLanhDao.DataValueField = "ID";
                dropLanhDao.DataTextField = "MA_TEN";
                dropLanhDao.DataBind();
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropTTV()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");

            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "TenCanBo";
                dropTTV.DataBind();
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void GetAllLanhDaoNhanBCTheoTTV(Decimal ThamTraVienID)
        {
            LoadDropLanhDao();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
            if (ThamTraVienID > 0)
            {
                DataTable tbl = objBL.GetLanhDaoNhanBCTheoTTV(PhongBanID, ThamTraVienID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string strLDVID = tbl.Rows[0]["ID"] + "";
                    dropLanhDao.SelectedValue = strLDVID;
                }
            }
        }

        protected void dropTTV_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            Cls_Comon.SetFocus(this, this.GetType(), dropLanhDao.ClientID);
        }
        //protected void LoadThamPhan()
        //{
        //    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
        //    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
        //    DataTable tbl =  oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
        //    if (tbl != null && tbl.Rows.Count > 0)
        //    {
        //        dropThamPhan.DataSource = tbl;
        //        dropThamPhan.DataValueField = "ID";
        //        dropThamPhan.DataTextField = "Hoten";
        //        dropThamPhan.DataBind();
        //        dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
        //    }
        //}

        protected void LoadThamPhan()
        {
            dropThamPhan.Items.Clear();
            Boolean IsLoadAll = false;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);


            GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                        dropThamPhan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                //DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dropThamPhan.DataSource = tbl;
                    dropThamPhan.DataValueField = "ID";
                    dropThamPhan.DataTextField = "Hoten";
                    dropThamPhan.DataBind();
                    dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
        }
        //-------------------------------------------
        void LoadInfoVuAn()
        {
            Decimal CurrDonID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single();
            if (obj != null)
            {
                //Kiem tra neu Ho so KN nhan tu HCTP (GDTTT_DON) thi khong được chuyen sang lại giai quyet khac
                List<GDTTT_DON> oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == CurrDonID && x.LOAIDON == 4).ToList();
                List<GDTTT_VUAN_KETQUA> lst = new List<GDTTT_VUAN_KETQUA>();
                lst = DataExtensions.GetAllByVuAnId<GDTTT_VUAN_KETQUA>(CurrDonID);
                if (oDon.Count() > 0 || lst.Count > 0)
                {
                    dropLoaiGDT.Enabled = false;
                    dropLoaiGDT.Items.Insert(1, new ListItem("Kháng nghị của VKS", "1"));
                }
                else
                {
                    dropLoaiGDT.Enabled = true;
                }

                ddl_LOAI_GDTTT.SelectedValue = Convert.ToString(obj.LOAI_GDTTTT);
                //----truong hop thu ly GDTT-------------   
                try
                {
                    Cls_Comon.SetValueComboBox(dropLoaiGDT, obj.TRUONGHOPTHULY);
                    if (obj.TRUONGHOPTHULY == 0 || obj.TRUONGHOPTHULY == null)
                    {
                        //pnThuLyDon.Visible = true;
                        pnThuLyDon.Visible = false;
                    }
                    else
                    {
                        pnThuLyDon.Visible = false;
                        if (obj.TRUONGHOPTHULY == 1)
                        {
                            pnHoSoVKS.Visible = pnThulyXXGDT.Visible = true;
                        }
                    }

                }
                catch (Exception ex) { }

                if (obj.ISVIENTRUONGKN == 1)
                {
                    pnThuLyDon.Visible = false;
                    pnHoSoVKS.Visible = pnThulyXXGDT.Visible = true;
                    cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = false;

                    txtVKS_So.Text = obj.VIENTRUONGKN_SO + "";
                    txtVKS_Ngay.Text = (String.IsNullOrEmpty(obj.VIENTRUONGKN_NGAY + "") || (obj.VIENTRUONGKN_NGAY == DateTime.MinValue)) ? "" : ((DateTime)obj.VIENTRUONGKN_NGAY).ToString("dd/MM/yyyy", cul);
                    LoadDropNGuoiKy_VKS();
                    Cls_Comon.SetValueComboBox(dropVKS_NguoiKy, obj.VIENTRUONGKN_NGUOIKY);
                    //----Thong tin thu ly xet xu GDT----------
                    txtSOTHULYXXGDT.Text = obj.SOTHULYXXGDT + "";
                    txtNgayTHULYXXGDT.Text = (String.IsNullOrEmpty(obj.NGAYTHULYXXGDT + "") || (obj.NGAYTHULYXXGDT == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULYXXGDT).ToString("dd/MM/yyyy", cul);
                    txtNgayVKSTraHS.Text = (String.IsNullOrEmpty(obj.XXGDTTT_NGAYVKSTRAHS + "") || (obj.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue)) ? "" : ((DateTime)obj.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul);

                }
                //----thong tin thu ly-----------------
                txtSoThuLy.Text = obj.SOTHULYDON + "";
                txtNgayThuLy.Text = (String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);
                txtNguoiDeNghi.Text = obj.NGUOIKHIEUNAI + "";
                txtNgayTrongDon.Text = (String.IsNullOrEmpty(obj.NGAYTRONGDON + "") || (obj.NGAYTRONGDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTRONGDON).ToString("dd/MM/yyyy", cul);
                txtNgayNhanDon.Text = (String.IsNullOrEmpty(obj.NGAYNHANDONDENGHI + "") || (obj.NGAYNHANDONDENGHI == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHANDONDENGHI).ToString("dd/MM/yyyy", cul);
                txtNguoiDeNghi_DiaChi.Text = obj.DIACHINGUOIDENGHI;

                //---------thong tin BA/QD----------------------
                try
                {
                    if (obj.LOAIAN < 10)
                        dropLoaiAn.SelectedValue = "0" + obj.LOAIAN + "";
                    else
                        dropLoaiAn.SelectedValue = obj.LOAIAN + "";
                    LoadDMQuanHePL();
                    LoadQHPLTK();
                }
                catch (Exception exx) { }
                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAQDID).FirstOrDefault();
                if (obj.BAQD_CAPXETXU == 4)
                {
                    LoadDropToaAnGDT_ALL();
                    hddIsAnPT.Value = "GDT";
                    pnQDGDT.Visible = true;
                    //LoadDropToaAnGDT(dropToaGDT);
                    if (obj.TOAQDID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaGDT, obj.TOAQDID);
                        if (oTA.LOAITOA != "CAPTINH")
                            LoadDropToaPT_TheoGDT(Convert.ToDecimal(obj.TOAQDID));
                    }
                   
                    if (oTA.LOAITOA == "CAPTINH")
                    {
                        pnPhucTham.Visible = false;
                        pnAnST.Visible = true;
                        LoadDropToaST_Full_ST();
                        if (obj.TOAANSOTHAM > 0)
                            Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    }
                    else {
                        pnPhucTham.Visible = pnAnST.Visible = true;
                        if (obj.TOAPHUCTHAMID > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                            }
                        if (obj.TOAANSOTHAM > 0)
                            Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    }

                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;


                }
                else if (obj.BAQD_CAPXETXU == 3)
                {
                    hddIsAnPT.Value = "PT";
                    pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAn();
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }
                else if (obj.BAQD_CAPXETXU == 2)
                {
                    hddIsAnPT.Value = "ST";
                    pnQDGDT.Visible = pnPhucTham.Visible = false;
                    pnAnST.Visible = true;
                    LoadDropToaST_Full();
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);

                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;
                }
                else
                {
                    hddIsAnPT.Value = "PT";
                    pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAn();
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }

                if (obj.BAQD_CAPXETXU != null)
                    Cls_Comon.SetValueComboBox(ddlLoaiBA, obj.BAQD_CAPXETXU);

                txtSoQĐGDT.Text = obj.SO_QDGDT;
                txtNgayGDT.Text = (String.IsNullOrEmpty(obj.NGAYQD + "") || (obj.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul);

                txtSoBA.Text = obj.SOANPHUCTHAM + "";
                txtNgayBA.Text = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);


                txtSoBA_ST.Text = obj.SOANSOTHAM;
                txtNgayBA_ST.Text = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);


                //-------------------------------
                if (obj.QHPL_DINHNGHIAID > 0 && string.IsNullOrEmpty(obj.QHPL_TEXT + ""))
                {
                    GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == obj.QHPL_DINHNGHIAID).FirstOrDefault();
                    if (oQHPL != null)
                    {
                        txtQHPL_TEXT.Text = oQHPL.TENQHPL;
                    }
                }
                else
                    txtQHPL_TEXT.Text = obj.QHPL_TEXT;
                //try { Cls_Comon.SetValueComboBox(dropQHPL, obj.QHPL_DINHNGHIAID); } catch (Exception ex) { }
                try { Cls_Comon.SetValueComboBox(dropQHPLThongKe, obj.QHPL_THONGKEID); } catch (Exception ex) { }

                LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);

                //----------thong tin TTV/LD---------------------
                LoadnInfo_TTV_LD_TP(obj);
            }
        }
        void LoadnInfo_TTV_LD_TP(GDTTT_VUAN obj)
        {
            int show_form = 0;
            decimal tempID = 0;
            decimal tempIDLD = 0;
            if (obj.ISVIENTRUONGKN == 1)
            {
                txtNgayphancong.Text = (String.IsNullOrEmpty(obj.XXGDT_NGAYPHANCONGTTV + "") || (obj.XXGDT_NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.XXGDT_NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
                tempID = (String.IsNullOrEmpty(obj.XXGDT_THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.XXGDT_THAMTRAVIENID);

                txtNgayPhanCong_LDV.Text = (String.IsNullOrEmpty(obj.XXGDT_NGAYPHANCONGLD + "") || (obj.XXGDT_NGAYPHANCONGLD == DateTime.MinValue)) ? "" : ((DateTime)obj.XXGDT_NGAYPHANCONGLD).ToString("dd/MM/yyyy", cul);
                tempIDLD = (String.IsNullOrEmpty(obj.XXGDT_LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.XXGDT_LANHDAOVUID);
            }
            else
            {
                txtNgayphancong.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTTV + "") || (obj.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
                tempID = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);

                txtNgayPhanCong_LDV.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGLD + "") || (obj.NGAYPHANCONGLD == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGLD).ToString("dd/MM/yyyy", cul);
                tempIDLD = (String.IsNullOrEmpty(obj.LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.LANHDAOVUID);
            }


            txtNgayNhanTieuHS.Text = (String.IsNullOrEmpty(obj.NGAYTTVNHAN_THS + "") || (obj.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);

            if (!string.IsNullOrEmpty(txtNgayphancong.Text))
            {
                show_form++;
                txtNgayphancong.Enabled = false;
            }



            if (tempID > 0)
            {
                try
                {
                    Cls_Comon.SetValueComboBox(dropTTV, tempID);
                    dropTTV.Enabled = false;
                    //chkModify_TTV.Visible = true;
                }
                catch (Exception ex) { }
                show_form++;
                GetAllLanhDaoNhanBCTheoTTV(tempID);
            }
            //-------------------------------

            if (!string.IsNullOrEmpty(txtNgayPhanCong_LDV.Text))
            {
                show_form++;
                txtNgayPhanCong_LDV.Enabled = false;
            }
            try
            {
                if (tempIDLD > 0)
                {
                    show_form++;
                    Cls_Comon.SetValueComboBox(dropLanhDao, tempIDLD);
                    dropLanhDao.Enabled = false;
                    //chkModify_LanhDao.Visible = true;
                }
            }
            catch (Exception ex) { }
            //--------------
            txtNgayGDNhanHS.Text = (String.IsNullOrEmpty(obj.NGAYVUGDNHAN_THS + "") || (obj.NGAYVUGDNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYVUGDNHAN_THS).ToString("dd/MM/yyyy", cul);
            tempID = (String.IsNullOrEmpty(obj.HOSOID + "")) ? 0 : Convert.ToDecimal(obj.HOSOID);
            if (tempID > 0)
            {
                GDTTT_QUANLYHS objHS = dt.GDTTT_QUANLYHS.Where(x => x.ID == tempID).Single();
                if (objHS != null)
                {
                    txtNgayNhanHS.Text = (String.IsNullOrEmpty(objHS.NGAYTAO + "") || (objHS.NGAYTAO == DateTime.MinValue)) ? "" : ((DateTime)objHS.NGAYTAO).ToString("dd/MM/yyyy", cul);
                    //Neu da co ho so thi khong cho sua
                    txtNgayNhanHS.Enabled = false;
                }
            }
            //---Kiem tra xem vu an có Don khong, Neu co thi khong cho chọn TP----------------------------
            List<GDTTT_DON> objDon = null;
            objDon = dt.GDTTT_DON.Where(x => x.VUVIECID == obj.ID).ToList();
            //-------------------------------
            txtNgayPhanCong_TP.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTP + "") || (obj.NGAYPHANCONGTP == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTP).ToString("dd/MM/yyyy", cul);
            if (!string.IsNullOrEmpty(txtNgayPhanCong_TP.Text))
                show_form++;
            try
            {
                tempID = (String.IsNullOrEmpty(obj.THAMPHANID + "")) ? 0 : Convert.ToDecimal(obj.THAMPHANID);
                if (tempID > 0)
                {
                    show_form++;
                    Cls_Comon.SetValueComboBox(dropThamPhan, tempID);
                    chkModify_TP.Visible = false;
                    //manhnd chi ap dung cho TANDTC
                    if (CurrDonViID == 1)
                        txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = false;
                }
                else
                {
                    if (objDon.Count > 0)
                    {
                        txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = false;
                        //manhnd chi ap dung cho TAND Cap Cao
                        if (CurrDonViID != 1)
                            txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = true;
                    }
                    else
                        txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = true;
                }

            }
            catch (Exception ex) { dropThamPhan.Enabled = false; }

            //-------------------------------
            txtGhiChu.Text = obj.GHICHU;
            if (!string.IsNullOrEmpty(txtGhiChu.Text))
                show_form++;
            //-------------------------------
            if (show_form > 0)
            {
                lkTTV.Text = "[ Thu gọn ]";
                pnTTV.Visible = true;
                Session[SessionTTV] = "0";
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu();
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Red;
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            GDTTT_VUAN obj = Update_VuAn();

            //Update duong su
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
                Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);


            ClearForm(false);
            //Response.Redirect("thongtinvuan.aspx?type=renew");
            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công! Bạn có thể tiếp tục cập nhật vụ án mới";
            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu();
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            GDTTT_VUAN obj = Update_VuAn();

            //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
            GDTTT_DON_BL objBL = new GDTTT_DON_BL();
            objBL.Update_Don_TH(obj.ID);

            //Update duong su
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
                LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            }

            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);
            LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);

            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);
            LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);

            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công!";
        }
        string CheckNhapDuongSu()
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                foreach (RepeaterItem item in rptNguyenDon.Items)
                {
                    count_item++;
                    TextBox txtTen = (TextBox)item.FindControl("txtTen");
                    if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                        StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                }
                if (!String.IsNullOrEmpty(StrNguyenDon))
                    StrNguyenDon = "nguyên đơn thứ " + StrNguyenDon;
            }
            //------------------------

            count_item = 0;
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                count_item++;
                TextBox txtTen = (TextBox)item.FindControl("txtTen");
                if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                    StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
            }
            if (!String.IsNullOrEmpty(StrBiDon))
                StrBiDon = "bị đơn  thứ " + StrBiDon;

            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
        }
        GDTTT_VUAN Update_VuAn()
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");

            if (CurrVuAnID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }
            else
                obj = new GDTTT_VUAN();

            obj.PHONGBANID = PhongBanID;//đơn vị sử dụng phần mềm
            if (IsUpdate == false)
                obj.PHONGBANGQ = PhongBanID;//đơn vị giải quyết
            obj.TOAANID = CurrDonViID;

            obj.LOAI_GDTTTT = Convert.ToDecimal(ddl_LOAI_GDTTT.SelectedValue);//anhvh add 26/04/2020

            //-----Truong hop thu ly--------------
            obj.TRUONGHOPTHULY = Convert.ToDecimal(dropLoaiGDT.SelectedValue);

            //-----Thong tin ThuLy-------------------
            if (Convert.ToDecimal(dropLoaiGDT.SelectedValue) == 0)
            {
                //Thụ lý theo đơn đề nghị GĐT
                obj.SOTHULYDON = txtSoThuLy.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayThuLy.Text.Trim()))
                    obj.NGAYTHULYDON = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYTHULYDON = null;

                if (!String.IsNullOrEmpty(txtNgayTrongDon.Text.Trim()))
                    obj.NGAYTRONGDON = DateTime.Parse(this.txtNgayTrongDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYTRONGDON = null;
                if (!String.IsNullOrEmpty(txtNgayNhanDon.Text.Trim()))
                    obj.NGAYNHANDONDENGHI = DateTime.Parse(this.txtNgayNhanDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYNHANDONDENGHI = null;

                obj.NGUOIKHIEUNAI = Cls_Comon.FormatTenRieng(txtNguoiDeNghi.Text.Trim());
                obj.DIACHINGUOIDENGHI = txtNguoiDeNghi_DiaChi.Text.Trim();
            }
            else
            {
                //Các trường hợp khác không theo đơn nên xóa thông tin này đi
                obj.SOTHULYDON = obj.NGUOIKHIEUNAI = obj.DIACHINGUOIDENGHI = null;
                obj.NGAYTHULYDON = obj.NGAYTRONGDON = obj.NGAYNHANDONDENGHI = null;
            }

            obj.LOAIAN = Convert.ToInt16(dropLoaiAn.SelectedValue);

            //------Thong tin QD GDT bị đề nghị------------------
            obj.BAQD_CAPXETXU = Convert.ToInt16(ddlLoaiBA.SelectedValue);
            if (pnQDGDT.Visible)
            {
                if (dropToaGDT.SelectedValue != "0" && dropToaGDT.SelectedValue != null)
                    obj.TOAQDID = Convert.ToDecimal(dropToaGDT.SelectedValue);
                obj.SO_QDGDT = txtSoQĐGDT.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayGDT.Text.Trim()))
                    obj.NGAYQD = DateTime.Parse(this.txtNgayGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYQD = null;
            }
            else
            {
                obj.SO_QDGDT = "";
                obj.NGAYQD = DateTime.MinValue;
                obj.TOAQDID = 0;
            }
            
            if (pnPhucTham.Visible)
            {
                if (dropToaAn.SelectedValue != "0" && dropToaAn.SelectedValue != null)
                    obj.TOAPHUCTHAMID = Convert.ToDecimal(dropToaAn.SelectedValue);
                obj.SOANPHUCTHAM = txtSoBA.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayBA.Text.Trim()))
                    obj.NGAYXUPHUCTHAM = DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYXUPHUCTHAM = null;
            }
            else
            {
                obj.SOANPHUCTHAM = "";
                obj.NGAYXUPHUCTHAM = DateTime.MinValue;
                obj.TOAPHUCTHAMID = 0;
            }
            if (pnAnST.Visible)
            {
                obj.SOANSOTHAM = txtSoBA_ST.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayBA_ST.Text.Trim()))
                    obj.NGAYXUSOTHAM = DateTime.Parse(this.txtNgayBA_ST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYXUSOTHAM = null;
                if (dropToaAnST.SelectedValue != "0" && dropToaAnST.SelectedValue != "")
                    obj.TOAANSOTHAM = Convert.ToDecimal(dropToaAnST.SelectedValue);
            }
            else
            {
                obj.SOANSOTHAM = "";
                obj.NGAYXUSOTHAM = DateTime.MinValue;
                obj.TOAANSOTHAM = 0;
            }

            obj.QHPL_TEXT = txtQHPL_TEXT.Text.Trim();
            obj.QHPL_DINHNGHIAID = null;
            //obj.QHPL_DINHNGHIAID = Convert.ToDecimal(dropQHPL.SelectedValue);

            obj.QHPL_THONGKEID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);

            //-----Thong tin TTV/LD---------Manhnd bo---------------
            //if (chkModify_TTV.Checked)
            //    UpdateHistory_PCCanBo(1);

            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
            {
                if (obj.ISVIENTRUONGKN == 1)
                    obj.XXGDT_NGAYPHANCONGTTV = DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYPHANCONGTTV = DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                if (obj.ISVIENTRUONGKN == 1)
                    obj.XXGDT_NGAYPHANCONGTTV = null;
                else
                    obj.NGAYPHANCONGTTV = null;
            }
            if (obj.ISVIENTRUONGKN == 1)
            {
                obj.XXGDT_THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
            }
            else
            {
                obj.THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
                obj.TENTHAMTRAVIEN = (dropTTV.SelectedValue == "0") ? "" : Cls_Comon.FormatTenRieng(dropTTV.SelectedItem.Text);
            }

            if (!String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim()))
                obj.NGAYTTVNHAN_THS = DateTime.Parse(this.txtNgayNhanTieuHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYTTVNHAN_THS = null;


            //if (chkModify_LanhDao.Checked)
            //    UpdateHistory_PCCanBo(2);
            if (obj.ISVIENTRUONGKN == 1)
            {
                obj.XXGDT_LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);
                if (!String.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim()))
                    obj.XXGDT_NGAYPHANCONGLD = DateTime.Parse(this.txtNgayPhanCong_LDV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.XXGDT_NGAYPHANCONGLD = null;
            }
            else
            {
                obj.LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);
                if (!String.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim()))
                    obj.NGAYPHANCONGLD = DateTime.Parse(this.txtNgayPhanCong_LDV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYPHANCONGLD = null;

            }

            if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                obj.NGAYVUGDNHAN_THS = DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYVUGDNHAN_THS = null;



            //if (chkModify_TP.Checked)
            //    UpdateHistory_PCCanBo(3);

            //GTEL-DUCPH 20-09-2025 fix bug khi dropThamPhan rỗng 
            if (!string.IsNullOrEmpty(dropThamPhan.SelectedValue)) //GTEL-DUCPH 20-09-2025 Kiểm tra giá trị selectedvalue trước khi gán
            {
                if (Convert.ToDecimal(dropThamPhan.SelectedValue) > 0)
                    obj.THAMPHANID = Convert.ToDecimal(dropThamPhan.SelectedValue);
                if (!String.IsNullOrEmpty(txtNgayPhanCong_TP.Text.Trim()))
                    obj.NGAYPHANCONGTP = DateTime.Parse(this.txtNgayPhanCong_TP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYPHANCONGTP = null;
            }

            //---------------------------------
            obj.GHICHU = txtGhiChu.Text.Trim();
            //---------------------------------
            if (!IsUpdate)
            {
                //Thông tin trạng thái thụ lý
                if (obj.THAMTRAVIENID > 0)
                    obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;
                else
                    obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = UserName;

                obj.ISTOTRINH = 0;
                dt.GDTTT_VUAN.Add(obj);
            }
            else
            {
                // kiem tra neu vu an co ket qua GQD roi thi khong cap nhat lai Trangthaiid nua
                if (obj.GQD_LOAIKETQUA == null)
                {
                    decimal count_tt = 0, vuan_trangthai = 0;
                    Decimal max_trangthai_tt = 0;
                    GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
                    DataTable tbl = oBL.VUAN_TOTRINH(CurrVuAnID);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        count_tt = tbl.Rows.Count;
                        max_trangthai_tt = Convert.ToDecimal(tbl.Rows[0]["TinhTrangID"] + "");
                        //-----------------------            
                        vuan_trangthai = (Decimal)obj.TRANGTHAIID;
                        GDTTT_DM_TINHTRANG obTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == vuan_trangthai).Single();
                        if (obTT != null)
                        {
                            if (obTT.GIAIDOAN < 3)
                            {
                                obj.TRANGTHAIID = max_trangthai_tt;
                            }
                        }
                    }
                    else
                    {
                        count_tt = 0;
                        decimal TTV = (string.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : (Decimal)obj.THAMTRAVIENID;
                        if (TTV > 0)
                            obj.TRANGTHAIID = 2;
                        else obj.TRANGTHAIID = 1;
                    }
                }

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
            }
            //-----------------------
            dt.SaveChanges();
            hddID.Value = obj.ID.ToString();

            //-----------------------
            try
            {
                Decimal HosoID = UpdateHoSo(obj);
                if (HosoID > 0)
                {
                    obj.HOSOID = HosoID;
                    obj.ISHOSO = 1;
                }
                else
                    obj.HOSOID = obj.ISHOSO = 0;
                dt.SaveChanges();
            }
            catch (Exception ex) { }
            //--------------------
            return obj;
        }
        void UpdateHistory_PCCanBo(int type)
        {
            decimal CanBoID = 0;
            DateTime? date_temp = (DateTime?)null;
            GDTTT_VUAN_PHANCONGCB_HISTORY obj = new GDTTT_VUAN_PHANCONGCB_HISTORY();
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            if (CurrVuAnID > 0)
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                switch (type)
                {
                    case 1:// TTV
                        CanBoID = (Decimal)oVA.THAMTRAVIENID;
                        date_temp = oVA.NGAYPHANCONGTTV;
                        break;
                    case 2://LD
                        CanBoID = (Decimal)oVA.LANHDAOVUID;
                        date_temp = oVA.NGAYPHANCONGLD;
                        break;
                    case 3://TP
                        CanBoID = (Decimal)oVA.THAMPHANID;
                        date_temp = oVA.NGAYPHANCONGTP;
                        break;
                }


                List<GDTTT_VUAN_PHANCONGCB_HISTORY> lst = null;
                lst = dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Where(x => x.VUANID == CurrVuAnID
                                                               && x.CANBOID == CanBoID
                                                               && x.LOAI == type
                                                               && x.TUNGAY == date_temp).ToList();
                if (lst != null && lst.Count > 0)
                {
                    //GDTTT_VUAN_PHANCONGCB_HISTORY oTemp = lst[0];
                    //obj.TUNGAY = date_temp;
                    //obj.CANBOID = CanBoID;
                }
                else
                {
                    obj = new GDTTT_VUAN_PHANCONGCB_HISTORY();
                    obj.TUNGAY = date_temp;
                    obj.CANBOID = CanBoID;
                    obj.VUANID = CurrVuAnID;
                    obj.LOAI = (decimal)type;
                    if (obj.CANBOID > 0)
                    {
                        dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Add(obj);
                        dt.SaveChanges();
                    }
                }
            }
        }


        Decimal UpdateHoSo(GDTTT_VUAN objVA)
        {
            DateTime date_temp;
            Decimal CurrHoSoID = 0;
            Decimal VuAn_HoSoID = String.IsNullOrEmpty(objVA.HOSOID + "") ? 0 : (decimal)objVA.HOSOID;
            GDTTT_QUANLYHS objHS = new GDTTT_QUANLYHS();
            decimal thamtravien_id = (decimal)objVA.THAMTRAVIENID;
            if (thamtravien_id > 0)
            {
                decimal vuan_id = (decimal)objVA.ID;
                string NhanHS = "3";
                Boolean IsUpdate = false;
                List<GDTTT_QUANLYHS> lstHS = null;
                try
                {
                    if (!String.IsNullOrEmpty(txtNgayNhanHS.Text.Trim()))
                    {
                        date_temp = DateTime.Parse(this.txtNgayNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        if (VuAn_HoSoID > 0)
                        {
                            try
                            {
                                objHS = dt.GDTTT_QUANLYHS.Where(x => x.ID == VuAn_HoSoID).Single();
                                CurrHoSoID = objHS.ID;
                                IsUpdate = true;
                            }
                            catch (Exception ex2)
                            {
                                IsUpdate = false;
                            }
                        }
                        else
                        {
                            lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == vuan_id
                                                                && x.CANBOID == thamtravien_id
                                                                && x.LOAI == NhanHS
                                                           ).OrderByDescending(x => x.NGAYTAO).ToList();
                            if (lstHS != null && lstHS.Count > 0)
                            {
                                foreach (GDTTT_QUANLYHS objTemp in lstHS)
                                {
                                    DateTime ngay_tao_hs = (DateTime)objTemp.NGAYTAO;
                                    if (ngay_tao_hs == date_temp)
                                    {
                                        IsUpdate = true;
                                        objHS = objTemp;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex) { }
                if (!IsUpdate)
                {
                    //manhnd them
                    DateTime ngaytao = System.DateTime.Now;
                    if (objHS.NGAYTAO == null)
                        ngaytao = System.DateTime.Now;
                    else
                        ngaytao = (DateTime)objHS.NGAYTAO;
                    // them mới
                    objHS = new GDTTT_QUANLYHS();
                    objHS.TRANGTHAI = 0;
                    objHS.VUANID = vuan_id;
                    objHS.SOPHIEU = GetNewSoPhieuNhanHS(3, ngaytao, CurrDonViID, PhongBanID);
                    objHS.GROUPID = Guid.NewGuid().ToString();
                    objHS.TENCANBO = dropTTV.SelectedItem.Text;
                    objHS.CANBOID = Convert.ToDecimal(dropTTV.SelectedValue);
                }
                if (!String.IsNullOrEmpty(txtNgayNhanHS.Text.Trim()))
                    objHS.NGAYTAO = DateTime.Parse(this.txtNgayNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else objHS.NGAYTAO = null;
                objHS.LOAI = NhanHS.ToString();
                //manhnd kiem tra nêu nhạp ngày Nhận hs thì mới tạo phieu nhận
                //if (!IsUpdate)
                if (!IsUpdate && !String.IsNullOrEmpty(txtNgayNhanHS.Text.Trim()))
                    dt.GDTTT_QUANLYHS.Add(objHS);
                dt.SaveChanges();
                CurrHoSoID = objHS.ID;
            }
            return CurrHoSoID;
        }
        Decimal GetNewSoPhieuNhanHS(decimal loaiphieu, DateTime NgayTao, decimal DonviID, decimal PhongbanID)
        {
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, DonviID, PhongbanID);
            return SoCV;
        }
        void Update_DuongSu(GDTTT_VUAN objVA, string tucachtt, Repeater rpt)
        {
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            bool IsUpdate = false;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            Decimal CurrDS = 0;
            String StrEditID = ",";
            String StrUpdate = "";
            int soluongdong = 0;
            Boolean IsNhapDiaChi = false;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(hddSoND.Value);
                    if (chkND.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(hddSoBD.Value);
                    if (chkBD.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(hddSoDSKhac.Value);
                    if (chkDSKhac.Checked)
                        IsNhapDiaChi = true;
                    break;
            }
            int count_item = 0;
            foreach (RepeaterItem item in rpt.Items)
            {
                count_item++;
                IsUpdate = false;

                #region Update duong su
                TextBox txtTen = (TextBox)item.FindControl("txtTen");
                DropDownList ddlNamsinh = (DropDownList)item.FindControl("ddlNamsinh");
                TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                if (!String.IsNullOrEmpty(txtTen.Text.Trim()))
                {
                    HiddenField hddDuongSuID = (HiddenField)item.FindControl("hddDuongSuID");
                    CurrDS = String.IsNullOrEmpty(hddDuongSuID.Value + "") ? 0 : Convert.ToDecimal(hddDuongSuID.Value);
                    if (CurrDS > 0)
                    {
                        try
                        {
                            obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == CurrDS && x.VUANID == CurrVuAnID).Single<GDTTT_VUAN_DUONGSU>();
                            if (obj != null)
                                IsUpdate = true;
                            else obj = new GDTTT_VUAN_DUONGSU();
                        }
                        catch (Exception ex) { obj = new GDTTT_VUAN_DUONGSU(); }
                    }
                    else
                        obj = new GDTTT_VUAN_DUONGSU();

                    obj.VUANID = CurrVuAnID;
                    obj.LOAI = 2;// Convert.ToInt16(dropDSLoai.SelectedValue);
                    obj.TUCACHTOTUNG = tucachtt; //dropDuongSu.SelectedValue;
                    //obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTen.Text.Trim());
                    //AnhPN 12/03/2026 - Sửa theo yêu cầu a duy => vụ 3 yêu cầu nhập như nào thì giữ nguyên tên không tự ý viết hoa
                    obj.TENDUONGSU = txtTen.Text.Trim();
                    if (ddlNamsinh.SelectedValue != "0")
                        obj.NAMSINH = Convert.ToDecimal(ddlNamsinh.SelectedValue);
                    else
                        obj.NAMSINH = null;

                    obj.GIOITINH = 2;
                    obj.ISINPUTADDRESS = (IsNhapDiaChi) ? 1 : 0;
                    if (IsNhapDiaChi)
                    {
                        obj.DIACHI = txtDiachi.Text.Trim();
                        DropDownList ddlTinhHuyen = (DropDownList)item.FindControl("ddlTinhHuyen");
                        obj.HUYENID = Convert.ToDecimal(ddlTinhHuyen.SelectedValue);
                    }
                    else
                    {
                        obj.DIACHI = "";
                        obj.HUYENID = 0;
                        obj.TINHID = 0;
                    }

                    if (!IsUpdate)
                    {
                        obj.NGAYTAO = DateTime.Now;
                        obj.NGUOITAO = UserName;
                        dt.GDTTT_VUAN_DUONGSU.Add(obj);
                        dt.SaveChanges();
                    }
                    else
                    {
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = UserName;
                        dt.SaveChanges();
                    }
                }
                #endregion

                //-------------------------
                if (obj.ID > 0)
                {
                    StrEditID += obj.ID.ToString() + ",";
                    StrUpdate += ((string.IsNullOrEmpty(StrUpdate + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(obj.TENDUONGSU);
                }
            }

            //-------------------------
            //StrUpdate = "";
            #region Update_ListNGUyenDon_BiDon Trong GDTTT_VuAn
            if (!String.IsNullOrEmpty(StrUpdate) && tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        objVA.NGUYENDON = StrUpdate;
                        hddSoND.Value = count_item.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        objVA.BIDON = StrUpdate;
                        hddSoBD.Value = count_item.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        hddSoDSKhac.Value = count_item.ToString();
                        break;
                }
                if (tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                {
                    objVA.TENVUAN = objVA.NGUYENDON + " - " + objVA.BIDON + " - " + txtQHPL_TEXT.Text;
                    dt.SaveChanges();
                }
            }
            #endregion

        }

        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm(true);
        }
        void ClearForm(Boolean IsRefresh)
        {
            txtSoThuLy.Text = txtNguoiDeNghi.Text = "";
            txtNgayThuLy.Text = txtNgayTrongDon.Text = txtNgayNhanDon.Text = "";
            txtNguoiDeNghi_DiaChi.Text = "";
            //--------------------------------
            dropLoaiAn.SelectedIndex = 0;
            LoadDMQuanHePL();
            txtSoBA.Text = txtNgayBA.Text = "";
            dropToaAn.SelectedIndex = 0;
            dropLoaiAn.SelectedIndex = 0;
            dropQHPL.SelectedIndex = 0;
            dropQHPLThongKe.SelectedIndex = 0;

            //--------------------------------
            dropTTV.SelectedIndex = 0;
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            //GTEL-DUCPH 20-09-2025 fix bug dropThamPhan bi rong 
            if (dropThamPhan.Items.Count > 0) dropThamPhan.SelectedIndex = 0; // Kiểm tra drop có items mới gán

            txtNgayNhanTieuHS.Text = "";
            txtNgayGDNhanHS.Text = "";
            txtGhiChu.Text = "";

            //--------------------------------
            if (IsRefresh == true && Request["ID"] != null)
                LoadInfoVuAn();
            else
            {
                hddID.Value = "0";
                chkDSKhac.Checked = chkBD.Checked = chkND.Checked = false;

                hddSoBD.Value = hddSoND.Value = "1";
                hddSoDSKhac.Value = "0";

                DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                rptNguyenDon.DataSource = tbl;
                rptNguyenDon.DataBind();

                tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                rptBiDon.DataSource = tbl;
                rptBiDon.DataBind();

                tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                rptDsKhac.DataSource = tbl;
                rptDsKhac.DataBind();
            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Session[SS_TK.ISHOME] = "1";
            Response.Redirect("Danhsach.aspx");
        }
        void LoadDsDuongSu(Repeater rpt, String tucachtt)
        {
            int count_all = 0, IsInputAddress = 0;

            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(CurrVuAnID, tucachtt);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                count_all = tbl.Rows.Count;
                IsInputAddress = Convert.ToInt16(tbl.Rows[0]["IsInputAddress"] + "");
            }
            else
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        hddSoND.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        hddSoBD.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        hddSoDSKhac.Value = "0";
                        break;
                }
                tbl = CreateTableNhapDuongSu(tucachtt);
            }
            rpt.DataSource = tbl;
            rpt.DataBind();

            //--------------------
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    if (count_all > 0)
                    {
                        hddSoND.Value = count_all.ToString();
                        chkND.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    if (count_all > 0)
                    {
                        hddSoBD.Value = count_all.ToString();
                        chkBD.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    if (count_all > 0)
                    {
                        hddSoDSKhac.Value = count_all.ToString();
                        chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
            }
        }
        void LoadDropNamSinh(DropDownList ddlNamsinh)
        {
            ddlNamsinh.Items.Clear();
            int year = DateTime.Now.Year;
            for (int i = year; i >= year - 100; i--)
            {
                ListItem li = new ListItem(i.ToString());
                ddlNamsinh.Items.Add(li);
            }
            ddlNamsinh.Items.Insert(0, new ListItem("Năm sinh", "0"));
            //ddlNamsinh.Items.FindByText(year.ToString()).Selected = true;

        }

        DataTable CreateTableNhapDuongSu(string tucachtt)
        {
            DataTable tbl = new DataTable();
            tbl.Columns.Add("ID");
            tbl.Columns.Add("Loai", typeof(int));
            tbl.Columns.Add("TenDuongSu", typeof(string));
            tbl.Columns.Add("NAMSINH", typeof(string));
            tbl.Columns.Add("DiaChi", typeof(string));
            tbl.Columns.Add("HUYENID", typeof(string));
            tbl.Columns.Add("IsDelete", typeof(int));
            tbl.Columns.Add("IsInputAddress", typeof(int));

            int soluongdong = 0;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(hddSoND.Value);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(hddSoBD.Value);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(hddSoDSKhac.Value);
                    break;
            }
            //-----------------------
            DataRow newrow = null;
            int count_item = 1;
            int IsInputAddress = 0;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            if (CurrVuAnID > 0)
            {
                GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                DataTable tblData = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
                if (tblData != null && tblData.Rows.Count > 0)
                {
                    IsInputAddress = (string.IsNullOrEmpty(tblData.Rows[0]["IsInputAddress"] + "")) ? 0 : Convert.ToInt16(tblData.Rows[0]["IsInputAddress"] + "");
                    int count_data = tblData.Rows.Count;
                    foreach (DataRow row in tblData.Rows)
                    {
                        switch (tucachtt)
                        {
                            case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                                chkND.Checked = (IsInputAddress == 0) ? false : true;
                                break;
                            case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                                chkBD.Checked = (IsInputAddress == 0) ? false : true;
                                break;
                            case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                                chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                                break;
                        }
                        if (count_item <= soluongdong)
                        {
                            newrow = tbl.NewRow();
                            newrow["ID"] = row["ID"];
                            newrow["Loai"] = row["Loai"]; //ca nhan
                            newrow["TenDuongSu"] = row["TenDuongSu"];
                            newrow["NAMSINH"] = row["NAMSINH"];
                            newrow["DiaChi"] = row["DiaChi"];
                            newrow["HUYENID"] = row["HUYENID"] + "";
                            newrow["IsDelete"] = 1;
                            newrow["IsInputAddress"] = IsInputAddress;
                            tbl.Rows.Add(newrow);
                            count_item++;
                        }
                    }
                }
            }
            if ((count_item - 1) < soluongdong)
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        IsInputAddress = (!chkND.Checked) ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        IsInputAddress = (!chkBD.Checked) ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        IsInputAddress = (!chkDSKhac.Checked) ? 0 : 1;
                        break;
                }
                for (int i = count_item; i <= soluongdong; i++)
                {
                    newrow = tbl.NewRow();
                    newrow["ID"] = 0;
                    newrow["Loai"] = "0"; //ca nhan
                    newrow["TenDuongSu"] = "";
                    newrow["NAMSINH"] = "";
                    newrow["DiaChi"] = "";
                    newrow["HUYENID"] = 0;
                    newrow["IsDelete"] = 0;
                    newrow["IsInputAddress"] = IsInputAddress;
                    tbl.Rows.Add(newrow);
                }
            }
            return tbl;
        }
        //---------------------------
        protected void rptDuongSu_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);
                DropDownList ddlNamsinh = (DropDownList)e.Item.FindControl("ddlNamsinh");
                ddlNamsinh.Items.Clear();
                int year = DateTime.Now.Year;
                for (int i = year; i >= year - 100; i--)
                {
                    ListItem li = new ListItem(i.ToString());
                    ddlNamsinh.Items.Add(li);
                }
                ddlNamsinh.Items.Insert(0, new ListItem("Năm sinh", "0"));

                string strNam = rowView["NAMSINH"] + "";
                if (strNam != "")
                    ddlNamsinh.SelectedValue = strNam;



                if (Convert.ToInt16(rowView["IsDelete"] + "") == 0)
                    lkXoa.Visible = false;

                try
                {
                    Panel pn = (Panel)e.Item.FindControl("pn");
                    pn.Visible = (string.IsNullOrEmpty(rowView["IsInputAddress"] + "") || Convert.ToInt16(rowView["IsInputAddress"] + "") == 0) ? false : true;

                    List<DM_HANHCHINH> lstTinhHuyen;
                    if (Session["DMTINHHUYEN"] == null)
                        lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
                    else
                        lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
                    DropDownList ddlTinhHuyen = (DropDownList)e.Item.FindControl("ddlTinhHuyen");
                    ddlTinhHuyen.DataSource = lstTinhHuyen;
                    ddlTinhHuyen.DataTextField = "MA_TEN";
                    ddlTinhHuyen.DataValueField = "ID";
                    ddlTinhHuyen.DataBind();
                    ddlTinhHuyen.Items.Insert(0, new ListItem("Tỉnh/Huyện", "0"));
                    if (pn.Visible)
                    {
                        HiddenField hddHuyenID = (HiddenField)e.Item.FindControl("hddHuyenID");
                        string strHID = hddHuyenID.Value + "";
                        if (strHID != "")
                            ddlTinhHuyen.SelectedValue = strHID;
                    }
                }
                catch (Exception ex) { }
            }
        }
        protected void rptNguyenDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    //LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    break;
            }
        }

        protected void rptBiDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    //LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    break;
            }
        }

        protected void rptDsKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    //LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    break;
            }
        }

        void Xoa_DS(decimal curr_duongsu_id, string tucachtt)
        {
            string temp = "";
            int count_ds = 0;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            if (curr_duongsu_id > 0)
            {
                GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    dt.GDTTT_VUAN_DUONGSU.Remove(oT);
                    dt.SaveChanges();
                }
                //------------------------------------

                List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                                            && x.TUCACHTOTUNG == tucachtt).ToList();
                if (lst != null && lst.Count > 0)
                {
                    count_ds = lst.Count;
                    foreach (GDTTT_VUAN_DUONGSU ds in lst)
                        temp += ((string.IsNullOrEmpty(temp + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(ds.TENDUONGSU);
                }
                //---------------------------
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                if (oVA != null)
                {
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                            oVA.NGUYENDON = temp;
                            hddSoND.Value = count_ds > 0 ? count_ds.ToString() : "1";
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            oVA.BIDON = temp;
                            hddSoBD.Value = count_ds > 0 ? count_ds.ToString() : "1";
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                            hddSoDSKhac.Value = count_ds.ToString();
                            break;
                    }

                    if (tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                    {
                        oVA.TENVUAN = oVA.NGUYENDON + " - " + oVA.BIDON + " - " + txtQHPL_TEXT.Text;
                        dt.SaveChanges();
                    }
                }
            }
            else
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        count_ds = (string.IsNullOrEmpty(hddSoND.Value + "")) ? 1 : Convert.ToInt16(hddSoND.Value) - 1;
                        hddSoND.Value = count_ds.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        count_ds = (string.IsNullOrEmpty(hddSoBD.Value + "")) ? 1 : Convert.ToInt16(hddSoBD.Value) - 1;
                        hddSoBD.Value = count_ds.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        count_ds = (string.IsNullOrEmpty(hddSoDSKhac.Value + "")) ? 0 : Convert.ToInt16(hddSoDSKhac.Value) - 1;
                        hddSoDSKhac.Value = count_ds.ToString();
                        break;
                }
            }

            //-------------------------------
            DataTable tbl = null;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    rptNguyenDon.DataSource = tbl;
                    rptNguyenDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    rptBiDon.DataSource = tbl;
                    rptBiDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    rptDsKhac.DataSource = tbl;
                    rptDsKhac.DataBind();
                    break;
            }
            lttMsg.Text = lttMsgT.Text = "Xóa thành công!";
        }

        //------------------------------
        string CheckNhapDuongSu_TheoLoai(string loai_ds)
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            switch (loai_ds)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    foreach (RepeaterItem item in rptNguyenDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrNguyenDon))
                        StrNguyenDon = "nguyên đơn thứ " + StrNguyenDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    foreach (RepeaterItem item in rptBiDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrBiDon))
                        StrBiDon = "bị đơn  thứ " + StrBiDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    break;
            }
            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
        }

        //-------------------------------------------       
        protected void chkND_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptNguyenDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkND.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemND_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            GDTTT_VUAN obj = Update_VuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
            hddSoND.Value = (Convert.ToInt32(hddSoND.Value) + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            rptNguyenDon.DataSource = tbl;
            rptNguyenDon.DataBind();
        }

        //--------------------------
        protected void chkBD_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkBD.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }

        protected void lkThemBD_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            GDTTT_VUAN obj = Update_VuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);

            int old = Convert.ToInt32(hddSoBD.Value);
            hddSoBD.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            rptBiDon.DataSource = tbl;
            rptBiDon.DataBind();
        }
        //---------------------------
        protected void chkDSKhac_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptDsKhac.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkDSKhac.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemDSKhac_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            GDTTT_VUAN obj = Update_VuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);

            int old = Convert.ToInt32(hddSoDSKhac.Value);
            hddSoDSKhac.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            rptDsKhac.DataSource = tbl;
            rptDsKhac.DataBind();
        }
        //---------------------------
        protected void lkTTV_Click(object sender, EventArgs e)
        {
            if (pnTTV.Visible == false)
            {
                lkTTV.Text = "[ Thu gọn ]";
                pnTTV.Visible = true;
                Session[SessionTTV] = "0";
            }
            else
            {
                lkTTV.Text = "[ Mở ]";
                pnTTV.Visible = false;
                Session[SessionTTV] = "1";
            }
        }


        //----Truong hop thu ly GĐT
        protected void dropLoaiGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal truonghopGDT = Convert.ToDecimal(dropLoaiGDT.SelectedValue);
            //-- 1 là KN VKS
            if (truonghopGDT == 1)
            {
                pnThuLyDon.Visible = false;
                pnHoSoVKS.Visible = pnThulyXXGDT.Visible = true;
                cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = false;

                LoadDropNGuoiKy_VKS();
            }
            else if (truonghopGDT == 2 || truonghopGDT == 3)
            {
                pnThuLyDon.Visible = pnHoSoVKS.Visible = pnThulyXXGDT.Visible = false;
                cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = true;
            }
            else
            {
                cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = true;
                pnThuLyDon.Visible = pnHoSoVKS.Visible = pnThulyXXGDT.Visible = false;
            }


        }
        //-----------------------
        protected void txtVKS_Ngay_TextChanged(object sender, EventArgs e)
        {

        }
        void LoadDropNGuoiKy_VKS()
        {
            dropVKS_NguoiKy.Items.Clear();
            DM_VKS_BL objBL = new DM_VKS_BL();
            DataTable tbl = objBL.GetAll_VKS_ToiCao_CapCao();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropVKS_NguoiKy.DataSource = tbl;
                dropVKS_NguoiKy.DataTextField = "Ten";
                dropVKS_NguoiKy.DataValueField = "ID";
                dropVKS_NguoiKy.DataBind();
            }
            dropVKS_NguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        //--------------------------------------------------
        protected void cmdUpdateVKS_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();

            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            if (CurrVuAnID == 0)
            {
                //obj = Update_VuAn();
                //CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
                lttMsgT.Text = "Bạn cần tạo thông tin vụ án trước!";
                txtSoBA_ST.Focus();
                return;

            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    //update thong tin vu an trươc
                    obj = Update_VuAn();
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }

            if (IsUpdate)
            {
                //-Thong tin KN của VKS---------
                obj.VIENTRUONGKN_SO = obj.GDQ_SO = txtVKS_So.Text;
                DateTime date_temp = (String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.VIENTRUONGKN_NGAY = obj.GDQ_NGAY = date_temp;
                obj.VIENTRUONGKN_NGUOIKY = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);
                obj.GQD_LOAIKETQUA = 1;//khang nghi
                obj.GQD_KETQUA = "Kháng nghị";
                obj.TRANGTHAIID = 14;
                //---------------------------------
                obj.ISVIENTRUONGKN = 1;
                //--Tham quyền xét xử
                if (dropVKS_NguoiKy.SelectedValue == "818"
                    || dropVKS_NguoiKy.SelectedValue == "819"
                    || dropVKS_NguoiKy.SelectedValue == "820"
                    || dropVKS_NguoiKy.SelectedValue == "821")
                    obj.THAMQUYENXXGDT = CurrDonViID;
                else
                    obj.THAMQUYENXXGDT = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);


                dt.SaveChanges();

                lttMsgHSKN_VKS.ForeColor = System.Drawing.Color.Blue;
                lttMsgHSKN_VKS.Text = "Cập nhật dữ liệu thành công!";
            }

        }
        protected void cmdXoa_VKS_Click(object sender, EventArgs e)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.VIENTRUONGKN_SO = obj.GDQ_SO = "";
                obj.VIENTRUONGKN_NGAY = obj.GDQ_NGAY = null;
                obj.VIENTRUONGKN_NGUOIKY = 0;
                obj.GQD_LOAIKETQUA = null;//khang nghi
                obj.GQD_KETQUA = null;
                obj.TRANGTHAIID = 1;
                obj.ISVIENTRUONGKN = null;

                dt.SaveChanges();
                //---------------------
                txtVKS_So.Text = txtVKS_Ngay.Text = "";
                dropVKS_NguoiKy.SelectedValue = "0";
                //---------------------
                lttMsg.ForeColor = System.Drawing.Color.Blue;
                lttMsg.Text = "Xóa dữ liệu thành công!";
            }

        }


        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {

        }
        //------------------------------
        protected void cmdUpdateTTXX_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            if (CurrVuAnID == 0)
            {
                //obj = Update_VuAn();
                //CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
                lttMsgHSKN_VKS.ForeColor = System.Drawing.Color.Blue;
                lttMsgHSKN_VKS.Text = "Bạn cần tạo thông tin hồ sơ VKS trước khi thụ lý xét xử GĐT!";

                return;
            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    //update thong tin vu an trươc
                    obj = Update_VuAn();
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }


            if (IsUpdate)
            {
                obj.SOTHULYXXGDT = txtSOTHULYXXGDT.Text.Trim();
                DateTime date_temp = (String.IsNullOrEmpty(txtNgayTHULYXXGDT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayTHULYXXGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYTHULYXXGDT = date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgayVKSTraHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayVKSTraHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.XXGDTTT_NGAYVKSTRAHS = date_temp;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;

                //-----------------------
                dt.SaveChanges();
                lttMsgTLXX.ForeColor = System.Drawing.Color.Blue;
                lttMsgTLXX.Text = "Cập nhật dữ liệu thành công!";
            }
            else
                lttMsgTLXX.Text = "Vụ án không tồn tại. Bạn hãy kiểm tra lại!";

        }
        protected void cmdXoa_TTXX_Click(object sender, EventArgs e)
        {
            //xoa Thông tin thụ lý xét xử GĐT,TT
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.SOTHULYXXGDT = "";
                obj.NGAYTHULYXXGDT = null;
                obj.NGAYLICHGDT = null;
                obj.XXGDTTT_NGAYVKSTRAHS = null;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = 14;

                dt.SaveChanges();
                //---------------------
                txtSOTHULYXXGDT.Text = txtNgayTHULYXXGDT.Text = txtNgayVKSTraHS.Text = "";
                //---------------------
                lttMsg.ForeColor = System.Drawing.Color.Blue;
                lttMsg.Text = "Xóa dữ liệu thành công!";
            }
        }
        //------------------------------

        bool CheckCongbo()
        {
            try
            {
                if (Request["type"].ToString() != null)
                {
                    return true;
                }
            }
            catch
            {

            }

            Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            decimal v_CAPXETXU = 0;
            if (oT.LOAI_GDTTTT == 1)
            {
                v_CAPXETXU = 4;
            }
            else if (oT.LOAI_GDTTTT == 2)
            {
                v_CAPXETXU = 6;
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {VuAnID} AND LOAIANID = {oT.LOAIAN} AND CAPXETXU = {v_CAPXETXU} AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdUpdateAndNew, false);
                Cls_Comon.SetButton(cmdLamMoi, false);

                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdUpdateAndNew2, false);
                Cls_Comon.SetButton(cmdLamMoi2, false);

                Cls_Comon.SetButton(cmdXoaTTXX, false);
                Cls_Comon.SetButton(cmdUpdateTTXX, false);

                Cls_Comon.SetButton(cmdXoa_VKS, false);
                Cls_Comon.SetButton(cmdUpdateVKS, false);
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Đã có thông tin về công bố! Không được cập nhật thông tin!')", true);
                return false;
            }

            return true;
        } 
    }
}