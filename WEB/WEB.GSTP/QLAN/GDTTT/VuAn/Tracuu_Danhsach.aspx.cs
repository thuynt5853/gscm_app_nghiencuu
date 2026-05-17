using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.GDTTT;
using System.Text;
namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class Tracuu_Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        Decimal trangthai_trinh_id = 0, PhongBanID = 0, CurrDonViID;
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        String SessionInBC = "GDTTTVA_INBC_VISIBLE";
        String SessionSearch = "TTTKVISIBLE";
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            //---------------------------
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
                    {
                        Session["V_COLUME"] = "NGAYTHULYDON";
                        Session["V_ASC_DESC"] = "DESC";
                    }
                    if ((Session[SessionSearch] + "") == "0")
                    {
                        pnTTTK.Visible = true;
                    }
                    if ((Session[SessionInBC] + "") == "0")
                    {
                        lkInBC_OpenForm.Text = "[ Thu gọn ]";
                        pnInBC.Visible = true;
                    }
                    //---------------------------
                    LoadDropBox();
                    SetGetSessionTK(false);
                    //-------------------------------
                    

                    if (Session[SS_TK.NGUYENDON] != null)
                        Load_Data();
                }


            }
            else
                Response.Redirect("/Login.aspx");
        }
        private void SetGetSessionTK(bool isSet)
        {
            try
            {
                if (isSet)
                {
                    Session[SS_TK.TOAANXX] = ddlToaXetXu.SelectedValue;
                    Session[SS_TK.SOBAQD] = txtSoQDBA.Text;
                    Session[SS_TK.NGAYBAQD] = txtNgayBAQD.Text;
                    Session[SS_TK.NGUOIGUI] = txtNguoiguidon.Text;
                    Session[SS_TK.COQUANCHUYENDON] = "";// txtCoquanchuyendon.Text;
                    Session[SS_TK.LOAIAN] = ddlLoaiAn.SelectedValue;
                    string vArrSelectID = "";
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                            else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                        }
                    }
                    if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";
                    Session[SS_TK.ARRSELECTID] = vArrSelectID;


                }
                else
                {
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        pnTTTK.Visible = true;
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        if (Session[SS_TK.LOAIAN] != null)
                            ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";
                        txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                        if (Session[SS_TK.TOAANXX] != null) 
                            ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";

                        
                        txtNguoiguidon.Text = Session[SS_TK.NGUOIGUI] + "";
                        
                       
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";


                    }
                }
            }
            catch (Exception ex) { }
        }
        private void LoadDropBox()
        {
            //Loại án
            LoadDropLoaiAn();

            LoadDropToaAn();
            //Load Thẩm phán
            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
            //Lãnh đạo
            //Lãnh đạo
            try { LoadDropLanhDao(); } catch (Exception ex) { }

            //Trình trạng thụ lý
            LoadDrop_TinhTrangThuLy();

        }

        void LoadDropThamphan()
        {
            Decimal ChucVuPCA = 0;
            Decimal ChucVuCA = 0;
            Decimal ChucDanh_TPTATC = 0;
            Decimal ChucDanh_TPCC = 0;
            try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucVuCA = dt.DM_DATAITEM.Where(x => x.MA == "CA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucDanh_TPCC = dt.DM_DATAITEM.Where(x => x.MA == "TPCC").FirstOrDefault().ID; } catch (Exception ex) { }

            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA || oCB.CHUCVUID == ChucVuCA)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
                {
                    //ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                    //----------anhvh add 30/10/2019
                    DataTable tbl = oGDTBL.GDTTT_Tp_Duoc_Phutrach(Session[ENUM_SESSION.SESSION_DONVIID] + "", Convert.ToInt32(oCB.ID));
                    ddlThamphan.DataSource = tbl;
                    ddlThamphan.DataTextField = "HOTEN";
                    ddlThamphan.DataValueField = "ID";
                    ddlThamphan.DataBind();
                }
                else
                    IsLoadAll = true;
            }
            else if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                //DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
                {
                    ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                }
                else
                    IsLoadAll = true;
            }
            else
                IsLoadAll = true;
            if (IsLoadAll)
            {
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }

        void LoadDrop_TinhTrangThuLy()
        {

            decimal[] kq = { 13, 14, 16, 18 };
            List<GDTTT_DM_TINHTRANG> lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1 && !kq.Contains(x.ID)).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);//anhvh add 05/04/2011 add check name phong ban cap cao

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
            {
                int count_lst = lst.Count;
            }

            lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1
                                                && x.ID >= 6 && x.ID != 10).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);//anhvh add

        }
        public List<GDTTT_DM_TINHTRANG> SetName_Vu_Phongban(List<GDTTT_DM_TINHTRANG> lst)
        {
            decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            foreach (GDTTT_DM_TINHTRANG its in lst)
            {

                if (PBID == 2 || PBID == 3 || PBID == 4)//vụ giám đốc kiểm tra
                {
                    if (its.MA == "04")
                    {
                        its.TENTINHTRANG = "Phó Vụ trưởng";
                    }
                    else if (its.MA == "05")
                    {
                        its.TENTINHTRANG = "Vụ trưởng";
                    }
                    else if (its.MA == "10")
                    {
                        its.TENTINHTRANG = "Báo cáo Hội đồng thẩm phán";
                    }
                }
                else
                {
                    if (its.MA == "04")
                    {
                        its.TENTINHTRANG = "Trưởng phòng";
                    }
                    else if (its.MA == "05")
                    {
                        its.TENTINHTRANG = "Phó trưởng phòng";
                    }
                    else if (its.MA == "10")
                    {
                        its.TENTINHTRANG = "Báo cáo Ủy ban thẩm phán";
                    }
                }
            }
            return lst;
        }
        void LoadDropToaAn()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
        }

        void LoadDropLanhDao()
        {
            decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
            int loai_hotro_db = (int)oGroup.LOAI;

            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            decimal chucdanh_id = (string.IsNullOrEmpty(oCB.CHUCDANHID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCDANHID);
            decimal chucvu_id = (string.IsNullOrEmpty(oCB.CHUCVUID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCVUID);
            if (chucvu_id > 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucvu_id).FirstOrDefault();
                if (oCD.MA == ENUM_CHUCVU.CHUCVU_PVT)
                {
                    
                    hddLoaiTK.Value = ENUM_CHUCVU.CHUCVU_PVT;
                }
                else
                {
                    Load_AllLanhDao();
                    // 042 la Pho truong phong quyen nhu TTV 
                    if ((oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV || oCD.MA == "042") && loai_hotro_db != 1)
                    {
                        
                        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                    }
                }
            }
            else if (chucdanh_id > 0)
            {
                Load_AllLanhDao();

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucdanh_id).Single();
                if ((oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV || oCD.MA == "TTVC") && loai_hotro_db != 1)
                {
                    
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                }
   
            }
        }
        void Load_AllLanhDao()
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            //---------------------
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            //-----------------------
            
        }



        void LoadDropLoaiAn()
        {
            //Decimal ChucVuPCA = 0;
            //try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }

            Boolean IsLoadAll = false;
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();

            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCD.MA == "TPTATC" || oCD.MA == "TPCC")
                {
                    oCD = dt.DM_DATAITEM.Where(x => x.ID == CurrChucVuID).FirstOrDefault();
                    if (oCD != null)
                    {
                        if (oCD.MA == "CA")
                            IsLoadAll = true;
                        else if (oCD.MA == "PCA")
                        {
                            LoadLoaiAnPhuTrach(oCB);
                        }
                    }
                    else
                        IsLoadAll = true;
                    if (IsLoadAll) LoadAllLoaiAn();
                }
                else
                {
                    if (obj.ISHINHSU == 1)
                    {
                        ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                        //dgList.Columns[6].Visible = false;
                        //dgList.Columns[5].HeaderText = "Bị cáo";
                        
                    }
                    LoadLoaiAnPhuTrach_TheoPB(obj);
                }
            }

            if (ddlLoaiAn.Items.Count > 1)
            {
                //anhvh add 05/04/2021 check loai an nếu tồn tại án hình sự thì không insert lựa chọn tất cả
                Boolean check_add = true;
                foreach (ListItem li in ddlLoaiAn.Items)
                {
                    if (li.Value == "01")
                    {
                        check_add = false;
                        break;
                    }
                }
                if (check_add == true)
                {
                    //ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
        }
        void LoadLoaiAnPhuTrach_TheoPB(DM_PHONGBAN obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
        }
        void LoadLoaiAnPhuTrach(DM_CANBO obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
            if (obj.ISHINHSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            }
        }

        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
        }


        private void Load_Data()
        {
            dgList.Visible = dgListHS.Visible = false;
            SetTieuDeBaoCao();
            lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            int sumTLM = 0;

            if (oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                DataTable oDT2 = getDS(10000, pageindex);
                for (int i = 0; i < oDT2.Rows.Count; i++)
                {
                    sumTLM = Convert.ToInt32(oDT2.Rows[i]["cThulymoi"]) + sumTLM;
                }
            }

            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án " + "<b>(" + sumTLM + " đơn TLM)</b> trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";

            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                
                dgListHS.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgListHS.DataSource = oDT;
                dgListHS.DataBind();
                dgListHS.Visible = true;
                dgList.Visible = false;
            }
            else if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HANHCHINH)
            {
               
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; dgListHS.Visible = false;
            }
            else
            {
                
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; dgListHS.Visible = false;
            }
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = "";
            string vBidon = "";
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = 0;
            decimal vLanhdao = 0;
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vQHPLID = 0;
            decimal vQHPLDNID = 0;
            string vCoquanchuyendon = "";// txtCoquanchuyendon.Text.Trim();
            string vNguoiGui = txtNguoiguidon.Text.Trim();

            decimal vTraloidon = 2;
            decimal vLoaiCVID = 0;
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = 0;
            decimal vKetquathuly = 3;
            decimal vKetquaxetxu = 0;

            int isTotrinh = 2;
            int isYKienKLToTrinh = 2;
            int isBuocTT = 0;
            int isMuonHoSo = 2;
            int LoaiAnDB = 0;
            String LoaiAnDB_TH = "";
            int isHoanTHA = 2;
            int typetb = 0;

            int is_dangkybaocao = 2;
            int captrinhtiep_id = 0;
            int type_hoidong_tp = 0;

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                vPhongbanID = 0;
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //--------------
            decimal _SodonTLM = 0;
            decimal _LoaiGDT = Convert.ToDecimal(ddlLoaiGDT.SelectedValue);
            String vQHPL_TD = "";
            
            String chk_conlai_s = "0";
            //-----------------------------
            //manhnd 
            decimal _loaingaysearch = 1;
            DateTime? vNgaySearch_Tu = (DateTime?)null;
            DateTime? vNgaySearch_Den = (DateTime?)null;
            //-----------------------------
            DataTable tbl = null;
            tbl = oBL.GDTTTT_TRACUU_VUAN_SEARCH(Session[ENUM_SESSION.SESSION_USERID] + "", chk_conlai_s, Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
               , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vTrangthai, vKetquathuly, vKetquaxetxu
               , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
               , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp, _ISXINANGIAM, _GDT_ISXINANGIAM, _SodonTLM, _LoaiGDT
               , vQHPL_TD, _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
            return tbl;
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            SetGetSessionTK(true);
        }
        String temp = "";

        void XoaVuAn(Decimal CurrVuAnID)
        {

            GDTTT_TUHINH_BL obl = new GDTTT_TUHINH_BL();
            decimal count_ds = obl.HOSO_TUHINH_BY_VUANID(CurrVuAnID);
            if (count_ds > 0)
            {
                lbtthongbao.Text = "Bạn không được xóa Vụ án khi hồ sơ đang xem xin ân giảm";
                return;
            }

            List<GDTTT_QUANLYHS> lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstHS != null && lstHS.Count > 0)
            {
                lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
                return;
            }
            else
            {
                List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == CurrVuAnID).ToList();
                if (lstTT != null && lstTT.Count > 0)
                {
                    lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
                    return;
                }
            }
            //------------------------           
            List<GDTTT_VUAN_DUONGSU> lstDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU objDS in lstDS)
                    dt.GDTTT_VUAN_DUONGSU.Remove(objDS);
            }
            dt.SaveChanges();
            //-----------------------------
            List<GDTTT_VUAN_THAMTRAVIEN> lstTTV = dt.GDTTT_VUAN_THAMTRAVIEN.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_THAMTRAVIEN objTTV in lstTTV)
                    dt.GDTTT_VUAN_THAMTRAVIEN.Remove(objTTV);
            }
            dt.SaveChanges();
            //---------------anhvh add 29/05/2021--------------
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst_td = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU_TOIDANH obj_td in lst_td)
                    dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(obj_td);
            }
            dt.SaveChanges();
            //---------------anhvh add 29/05/2021--------------
            List<GDTTT_VUAN_DS_KN> lst_kn = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_DS_KN obj_kn in lst_kn)
                    dt.GDTTT_VUAN_DS_KN.Remove(obj_kn);
            }
            dt.SaveChanges();
            //-----------------------------
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
            dt.GDTTT_VUAN.Remove(oT);
            dt.SaveChanges();
            //-----------------------
            List<GDTTT_DON> lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == CurrVuAnID && x.CD_TRANGTHAI == 2).ToList();
            if (lstDon != null && lstDon.Count > 0)
            {
                foreach (GDTTT_DON oDon in lstDon)
                    oDon.VUVIECID = 0;
            }
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void cmd_ORDER_Click(object sender, ImageClickEventArgs e)
        {
            ImageButton img = (ImageButton)sender;
            String v_name_colum = img.CommandArgument;
            if (v_name_colum == "NGAYTHULYDON")
            {
                if (Session["V_COLUME"] + "" != "NGAYTHULYDON")
                {
                    Session.Remove("V_COLUME"); Session.Remove("V_ASC_DESC");
                }
                if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
                {
                    Session["V_COLUME"] = "NGAYTHULYDON";
                    Session["V_ASC_DESC"] = "ASC";
                }
                else if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    Session["V_COLUME"] = "NGAYTHULYDON";
                    Session["V_ASC_DESC"] = "DESC";
                }
                else if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    Session["V_COLUME"] = "NGAYTHULYDON";
                    Session["V_ASC_DESC"] = "ASC";
                }
            }
            else if (v_name_colum == "TENTHAMTRAVIEN")
            {
                if (Session["V_COLUME"] + "" != "TENTHAMTRAVIEN")
                {
                    Session.Remove("V_COLUME"); Session.Remove("V_ASC_DESC");
                }
                if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
                {
                    Session["V_COLUME"] = "TENTHAMTRAVIEN";
                    Session["V_ASC_DESC"] = "ASC";
                }
                else if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    Session["V_COLUME"] = "TENTHAMTRAVIEN";
                    Session["V_ASC_DESC"] = "DESC";
                }
                else if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    Session["V_COLUME"] = "TENTHAMTRAVIEN";
                    Session["V_ASC_DESC"] = "ASC";
                }
            }

            Load_Data();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Header)
            {
                ImageButton cmd_NGAYTHULYDON_ORDER = (ImageButton)e.Item.FindControl("cmd_NGAYTHULYDON_ORDER");
                ImageButton cmd_TENTHAMTRAVIEN_ORDER = (ImageButton)e.Item.FindControl("cmd_TENTHAMTRAVIEN_ORDER");
                if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    cmd_NGAYTHULYDON_ORDER.ImageUrl = "/UI/img/orders_up.png";
                }
                if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    cmd_NGAYTHULYDON_ORDER.ImageUrl = "/UI/img/orders_down.png";
                }
                if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    cmd_TENTHAMTRAVIEN_ORDER.ImageUrl = "/UI/img/orders_up.png";
                }
                if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    cmd_TENTHAMTRAVIEN_ORDER.ImageUrl = "/UI/img/orders_down.png";
                }
                //----------------------------
                
            }

            //-------------------------------
            //if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            //{
            //    DataRowView rv = (DataRowView)e.Item.DataItem;
            //    string strID = e.Item.Cells[0].Text;
            //    Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");
            //int count = 0;
            //string StrDisplay = "", temp = "";
            //string[] arr = null;
            //Decimal CurrVuAnID = Convert.ToDecimal(hddCurrID.Value);
            //String PhanCongTTV = rv["PhanCongTTV"] + "";
            //if (!String.IsNullOrEmpty(PhanCongTTV))
            //{
            //    lttTTV.Text = " TTV: <b>" + rv["TenThamTraVien"] + (String.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (" (" + rv["NGAYPHANCONGTTV"] + ")")) + "</b>";
            //    arr = PhanCongTTV.Split("*".ToCharArray());
            //    foreach (String str in arr)
            //    {
            //        if (str != "")
            //        {
            //            if (count == 0)
            //                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
            //            else
            //                StrDisplay += "<br/>- " + str;
            //            count++;
            //        }
            //    }
            //}
            //else lttTTV.Text = " TTV: <b>" + rv["TenThamTraVien"] + "</b>";
            //lttTTV.Text += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";
            //lttTTV.Text =  rv["PhanCongTTV"] + "";
            //---------------------
            //}
            //--------------------------------------------------
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                temp = "";
                DataRowView rv = (DataRowView)e.Item.DataItem;


                //------------------------
                int loaian = String.IsNullOrEmpty(rv["LoaiAN"] + "") ? 0 : Convert.ToInt16(rv["LoaiAN"] + "");
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");

                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                if (trangthai==13 || trangthai==14|| trangthai==15|| trangthai==16)
                {
                    string LoaiKN = (rv["IsVienTruongKN"].ToString() == "0") ? "(CA)" : "(VKS)";
                    lttLanTT.Text = "<b>" + rv["TENTINHTRANG"] + "</b>";
                    //-----manh kiem tra xem neu da co ket qua KQD thi không cho xoa vu an----------
                    //Tạm chua ap dung
                    //int v_gqd_loaiketqua = String.IsNullOrEmpty(rv["KQ_GQD_ID"] + "") ? 4 : Convert.ToInt32(rv["KQ_GQD_ID"] + "");
                    //if (v_gqd_loaiketqua == 0 || v_gqd_loaiketqua == 1 || v_gqd_loaiketqua == 2)
                    //    lbtXoa.Visible = lblSua.Visible = false;
                    if (trangthai == (int)ENUM_GDTTT_TRANGTHAI.KHANGNGHI)
                        lttLanTT.Text += " " + LoaiKN;
                    int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");
                    if (trangthai != ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV && GiaiDoanTrinh == 2)
                    {
                        #region Thông tin lien quan den To trinh
                        try
                        {
                            trangthai_trinh_id = Convert.ToDecimal(trangthai);
                            List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == CurrVuAnID
                                                              && x.TINHTRANGID == trangthai_trinh_id).OrderByDescending(y => y.NGAYTRINH).ToList();
                            if (lstTT != null && lstTT.Count > 0)
                            {
                                lttLanTT.Text = "<b>" + rv["TENTINHTRANG"] + " lần " + lstTT.Count.ToString() + "</b>";

                                GDTTT_TOTRINH objTT = lstTT[0];
                                if (!string.IsNullOrEmpty(objTT.NGAYTRINH + "") || (DateTime)objTT.NGAYTRINH != DateTime.MinValue)
                                    lttDetaiTinhTrang.Text = "<br/><span style='margin-right:10px;'>Ngày trình: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul) + "</span>";
                                if (!string.IsNullOrEmpty(objTT.NGAYTRA + "") || (DateTime)objTT.NGAYTRA != DateTime.MinValue)
                                    lttDetaiTinhTrang.Text += "<br/><span style='margin-right:10px;'>Ngày trả: " + Convert.ToDateTime(objTT.NGAYTRA).ToString("dd/MM/yyyy", cul) + "</span>";

                                lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(lttDetaiTinhTrang.Text)) ? "" : "<br/>";
                                lttDetaiTinhTrang.Text += objTT.YKIEN + "";
                            }
                        }
                        catch (Exception ex) { }
                        #endregion
                    }
                    else
                    {
                        if (trangthai == (int)ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV)
                        {
                            //hien ngay phan cong + qua trinh_ghi chu (GDTTT_VuAn)                       
                            lttDetaiTinhTrang.Text = (string.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (rv["NGAYPHANCONGTTV"].ToString() + "<br/>"))
                                                        + rv["QUATRINH_GHICHU"] + "";
                        }
                        else if (trangthai != 15)
                        {
                            int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 5 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                            if (loai_giaiquyet_don <= 2)
                            {
                                if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                                {
                                    lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                    if (loai_giaiquyet_don == 0)
                                        lttDetaiTinhTrang.Text = rv["AHS_THONGTINGQD"] + "";
                                    else
                                    {
                                        temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                        temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                        temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                        //----Có kết quả trả lời đơn---------------
                                        List<GDTTT_DON_TRALOI> lstTLD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == CurrVuAnID && x.TYPETB == 3).ToList();
                                        if (lstTLD.Count > 0)
                                            temp += "</br> <b><b>Trả lời đơn </b></b> </br>" + rv["AHS_THONGTINGQD"] + "";

                                        lttDetaiTinhTrang.Text = temp;
                                    }
                                }
                                else
                                {
                                    lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                    temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                    temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                    lttDetaiTinhTrang.Text = temp;
                                }
                            }
                            else if (loai_giaiquyet_don == 4)
                                lttLanTT.Text = "<b>Thông báo VKS " + " </b><br/>" + rv["KQ_GQD"];
                            else if (loai_giaiquyet_don == 3)
                                lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                            //KQGQ_THS kết quả giải quyết đơn đề nghị và các tài liệu kèm theo
                        }
                        else if (trangthai == 15)
                        {
                            lttLanTT.Text = "<b>Kháng nghị " + rv["LoaiKN"].ToString() + " </b>";
                            temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                            temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                            lttLanTT.Text += (String.IsNullOrEmpty(temp) ? "" : "</br>") + temp;
                            //-------thong tin thu ly XXGDTTT------------------------------
                            if (Convert.ToInt16(rv["IsRutKN"] + "") == 0)
                            {

                                int soluong1 = String.IsNullOrEmpty(rv["IsHoSo"] + "") ? 0 : Convert.ToInt32(rv["IsHoSo"] + "");
                                if (rv["TENTINHTRANG"].ToString().StartsWith("Thụ lý xét xử GĐT,TT") && soluong1 > 0)
                                {

                                }
                                else
                                {
                                    if (String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                                    {

                                    }
                                    else
                                    {
                                        //if (lttLanTT.Text.Length > 0)
                                        //    lttLanTT.Text += "<span class='line_space'></span>";
                                        //lttLanTT.Text += "<b style='float:left;width:100%;'>" + rv["TENTINHTRANG"] + "</b>";

                                        ////So/ngay thu ly XXGDTTT
                                        //lttDetaiTinhTrang.Text = (String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "")) ? "" : "<span style = 'margin-right:10px;' >Số TL: " + rv["SOTHULYXXGDT"].ToString()
                                        //                         + ((string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : "Ngày TL: " + rv["NGAYTHULYXXGDT"].ToString());
                                    }
                                }
                                if (String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                                {
                                    if (lttLanTT.Text.Length > 0)
                                        lttLanTT.Text += "<span class='line_space'></span>";
                                    lttLanTT.Text += "<b style='float:left;width:100%;'>Đang giải quyết</b>";
                                }
                                else
                                {

                                }
                            }
                        }

                    }
                    //-------------------------------
                    if (Convert.ToInt16(rv["IsRutKN"] + "") > 0)
                    {
                        if (lttLanTT.Text.Length > 0)
                            lttLanTT.Text += "<br/><span class='line_space'></span>";
                        lttLanTT.Text += "<br/><b>Rút kháng nghị</b>";
                        temp = String.IsNullOrEmpty(rv["SORUTKN"] + "") ? "" : "Số <b>" + rv["SORUTKN"].ToString() + "</b>";
                        if ((temp != "") && (!String.IsNullOrEmpty(rv["NGAYRUTKN"].ToString())))
                            temp += " ngày <b>" + rv["NGAYRUTKN"] + "" + "</b>";
                        if (!String.IsNullOrEmpty(temp))
                            lttLanTT.Text += "<br/>" + temp;
                    }
                    //-------------------------------
                    Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                    if (trangthai != 15)
                    {
                        int IsHoanTHA = Convert.ToInt16(rv["GQD_ISHOANTHA"] + "");
                        if (IsHoanTHA > 0)
                        {
                            lttKQGQ.Text = "<span class='line_space'>";
                            lttKQGQ.Text += "<b>Hoãn thi hành án</b>" + "<br/>";
                            lttKQGQ.Text += "<span style='margin-right:10px;'>Số: <b>" + rv["GQD_HoanTHA_So"].ToString() + "</b></span>";
                            lttKQGQ.Text += "<span style=''>Ngày: <b>" + rv["GQD_HoanTHA_Ngay"].ToString() + "</b></span><br/>";
                            lttKQGQ.Text += "";
                            lttKQGQ.Text += "</span>";
                        }
                    }
                    else
                    {
                        #region XXGDTTT
                        int IsHoan = Convert.ToInt16(rv["XXGDTTT_ISHOANPT"] + "");
                        if (IsHoan > 0)
                        {
                            lttKQGQ.Text = "<span class='line_space'>";
                            lttKQGQ.Text += "<b>Hoãn xét xử</b>" + "<br/>";
                            lttKQGQ.Text += "<span style='margin-right:10px;'>Ngày: <b>" + rv["XXGDTTT_NGAYHOAN"].ToString() + "</b></span>";
                            if (!String.IsNullOrEmpty(rv["XXGDTTT_LYDOHOAN"] + ""))
                                lttKQGQ.Text += "<br/>";
                            //lttKQGQ.Text += "<span style=''>Lý do: <b>" + rv["XXGDTTT_LYDOHOAN"].ToString() + "</b></span>";
                            lttKQGQ.Text += "<br/>";
                            lttKQGQ.Text += "</span>";
                        }
                        else
                        {
                            if (!String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                            {
                                lttKQGQ.Text = "<span class='line_space'>";
                                lttKQGQ.Text += "<b>Kết quả XX</b>" + "<br/>";
                                //--------------------------                    
                                if (!String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                                    lttKQGQ.Text += "<span style=''>Ngày xử: <b>" + rv["NGAYXUGIAMDOCTHAM"].ToString() + "</b></span>";

                                if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + "") || !String.IsNullOrEmpty(rv["XXGDTTT_NGAYQD"] + ""))
                                {
                                    lttKQGQ.Text += "<br/>";
                                    if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                        lttKQGQ.Text += "<span style='margin-right:10px;'>Số QĐ: <b>" + rv["XXGDTTT_SOQD"].ToString() + "</b></span>";
                                    if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                        lttKQGQ.Text += "<span style=''>Ngày QĐ: <b>" + rv["XXGDTTT_NGAYQD"].ToString() + "</b></span>";
                                }
                                //if (!String.IsNullOrEmpty(rv["KetQuaXXGDT"] + ""))
                                //{
                                //    lttKQGQ.Text += "<br/>";
                                //    lttKQGQ.Text += "<span style=''>KQ: <b>" + rv["KetQuaXXGDT"].ToString() + "</b></span>";
                                //}
                                //if (!String.IsNullOrEmpty(rv["HOIDONGXX"] + ""))
                                //{
                                //    lttKQGQ.Text += rv["HOIDONGXX"];
                                //}
                                //if (!String.IsNullOrEmpty(rv["TEN_CHUTOA"] + ""))
                                //{
                                //    lttKQGQ.Text += rv["TEN_CHUTOA"];
                                //}
                                lttKQGQ.Text += "</span>";
                            }
                        }
                        #endregion
                    }

                    //---------------------------
                    Literal lttOther = (Literal)e.Item.FindControl("lttOther");
                    string NgayTTVNhanHS = rv["NGAYTTVNHANHS"] + "";
                    int soluong = String.IsNullOrEmpty(rv["IsHoSo"] + "") ? 0 : Convert.ToInt32(rv["IsHoSo"] + "");

                    //lttOther.Text = (soluong > 0) ? ("<div class='line_space'><b>" + "Đã có hồ sơ" + (string.IsNullOrEmpty(NgayTTVNhanHS) ? "" : " (" + NgayTTVNhanHS + ")") + "</b></div>") : "";
                }
                else
                {
                    lttLanTT.Text = "<b style='float:left;width:100%;'>Đang giải quyết</b>";
                }


            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal vuanid = 0;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    SetGetSessionTK(true);
                    string[] arr = e.CommandArgument.ToString().Split('#');
                    if (arr.Length > 0)
                    {
                        int loaian = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToInt16(arr[1] + "");
                        vuanid = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");
                        if (loaian != Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            Response.Redirect("Thongtinvuan.aspx?ID=" + vuanid);
                        else
                            Response.Redirect("ThongtinvuanHS.aspx?ID=" + vuanid);
                    }
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    XoaVuAn(Convert.ToDecimal(e.CommandArgument));
                    break;
                //case "QLHS":
                //    string StrQLHS = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLHoso.aspx?vid=" + e.CommandArgument + "','Quản lý mượn trả hồ sơ',1000,600);";
                //    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrQLHS, true);
                //    break;
                //case "TOTRINH":
                //    string StrTotrinh = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLTotrinh.aspx?vid=" + e.CommandArgument + "','Quản lý tờ trình',1000,700);";
                //    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrTotrinh, true);
                //    break;
                case "KETQUA":
                    string StrKetqua = "PopupReport('/QLAN/GDTTT/VuAn/Popup/Ketqua.aspx?vid=" + e.CommandArgument + "','Kết quả giải quyết',850,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrKetqua, true);
                    break;
                case "SoDonTrung":
                    //string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?type=dt&vID=" + e.Item.Cells[0].Text + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;
                case "CongVan81":
                    string StrMsgArr81 = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonQuocHoi.aspx?vID=" + e.Item.Cells[0].Text + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr81, true);
                    break;
                case "CHIDAO":
                    string StrMsgChidao = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonChidao.aspx?vID=" + e.Item.Cells[0].Text + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgChidao, true);
                    break;
            }
        }
        protected void dgListHS_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
        //---------------CHỨC NĂNG-------------------
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }

        //protected void lbtTTTK_Click(object sender, EventArgs e)
        //{
        //    if (pnTTTK.Visible == false)
        //    {
        //        lbtTTTK.Text = "[ Thu gọn ]";
        //        pnTTTK.Visible = true;
        //        Session[SessionSearch] = "0";
        //    }
        //    else
        //    {
        //        lbtTTTK.Text = "[ Nâng cao ]";
        //        pnTTTK.Visible = false;
        //        Session[SessionSearch] = "1";
        //    }
        //}

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(false);
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;

            ddlThamphan.SelectedIndex = 0;
            txtThuly_So.Text = "";

            txtNguoiguidon.Text = string.Empty;
            
            Session.Remove("V_COLUME");
            Session.Remove("V_ASC_DESC");
            if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
            {
                Session["V_COLUME"] = "NGAYTHULYDON";
                Session["V_ASC_DESC"] = "DESC";
            }

        }
        //---------------------------------
        protected void lkInBC_OpenForm_Click(object sender, EventArgs e)
        {
            if (pnInBC.Visible == false)
            {
                lkInBC_OpenForm.Text = "[ Thu gọn ]";
                pnInBC.Visible = true;
                Session[SessionInBC] = "0";
            }
            else
            {
                lkInBC_OpenForm.Text = "[ Mở ]";
                pnInBC.Visible = false;
                Session[SessionInBC] = "1";
            }
        }
        protected void cmdPrint_Click_Older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
            String Parameter = "type=va&rID=" + dropMauBC.SelectedValue;
            DataTable tbl = SearchNoPaging();
            Session[SessionName] = tbl;
            string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(Parameter) ? "" : "?" + Parameter);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
        }
        //anhvh add 20/12/2019
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            try
            {
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
                decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

                string vNguyendon = "";
                string vBidon = "";
                decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                decimal vThamtravien = 0;
                decimal vLanhdao = 0;
                decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
                decimal vQHPLID = 0;
                decimal vQHPLDNID = 0;
                string vCoquanchuyendon = "";// txtCoquanchuyendon.Text.Trim();
                string vNguoiGui = txtNguoiguidon.Text.Trim();

                decimal vTraloidon = 2;
                decimal vLoaiCVID = 0;
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;
                decimal vTrangthai = 0;
                decimal vKetquathuly = 3;
                decimal vKetquaxetxu = 0;

                int isTotrinh = 2;
                int isYKienKLToTrinh = 2;
                int isBuocTT = 0;
                int isMuonHoSo = 2;
                int LoaiAnDB = 0;
                String LoaiAnDB_TH = "";
                int isHoanTHA = 2;
                int typetb = 0;

                int is_dangkybaocao = 2;
                int captrinhtiep_id = 0;
                int type_hoidong_tp = 0;

                if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                    vPhongbanID = 0;
                //anhvh phân quyên liên quan đến án tử hình
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
                decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
                //--------------
                decimal _SodonTLM = 0;
                decimal _LoaiGDT = Convert.ToDecimal(ddlLoaiGDT.SelectedValue); ;
                String vQHPL_TD = "";

                String chk_conlai_s = "0";
                //-----------------------------
                //manhnd 
                decimal _loaingaysearch = 1;
                DateTime? vNgaySearch_Tu = (DateTime?)null;
                DateTime? vNgaySearch_Den = (DateTime?)null;
                //-----------------------------
                DataTable tbl = null;
                tbl = oBL.VUAN_TRACUU_SEARCH_PRINT(chk_conlai_s, Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                   , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                   , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
                   , vTrangthai, vKetquathuly, vKetquaxetxu
                   , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
                   , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp, _ISXINANGIAM, _GDT_ISXINANGIAM, _SodonTLM, _LoaiGDT
                   , vQHPL_TD, _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den
                   , 0, 0);

                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (vToaAnID == 1)
                {
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        row = tbl.Rows[0];
                        Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                    }
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.doc");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.ContentType = "application/msword";
                    HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                    Response.Write("<html");
                    Response.Write("<head>");
                    Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                    Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                    Response.Write("<meta name=ProgId content=Word.Document>");
                    Response.Write("<meta name=Generator content=Microsoft Word 9>");
                    Response.Write("<meta name=Originator content=Microsoft Word 9>");
                    Response.Write("<style>");
                    Response.Write("<!-- /* Style Definitions */" +
                                                  "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                                  "{margin:0in;" +
                                                  "margin-bottom:.0001pt;" +
                                                  "mso-pagination:widow-orphan;" +
                                                  "tab-stops:center 3.0in right 6.0in;" +
                                                  "font-size:12.0pt;}");

                    Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                    Response.Write("div.Section1 {page:Section1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
                    Response.Write("div.Section2 {page:Section2;}");
                    Response.Write("<style>");
                    Response.Write("</head>");
                    Response.Write("<body>");
                    Response.Write("<div class=Section2>");//chỉ định khổ giấy
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</div>");
                    Response.Write("</body>");
                    Response.Write("</html>");
                    Response.End();
                }
                else
                {
                    //String INSERT_PAGE_BREAK = "";
                    //-----------
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        row = tbl.Rows[0];
                        Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                        //INSERT_PAGE_BREAK = row["INSERT_PAGE_BREAK"] + "";
                    }
                    //-------------------Export---------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.xls");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.ContentType = "application/vnd.xls";
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</body>");   // add the style props to get the page orientation
                    Response.Write("</html>");   // add the style props to get the page orientation
                    Response.End();
                }

            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_Data();
            // LoadDropQHPL();
        }
        private string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....            
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }

        private DataTable SearchNoPaging()
        {
            //decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            //GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            //decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            //string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            //string vNguoiGui = txtNguoiguidon.Text.Trim();
            //string vSoThuly = txtThuly_So.Text;
            //string vNgaythuly = txtNgaythuly.Text;
            //DataTable oDT = null;

            //oDT = oBL.VUAN_TraCuu_Search_NoPaging(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui,vSoThuly);
            return null;
        }
        

        void SetTieuDeBaoCao()
        {
            string tieudebc = "";

            
            //-------------------------------------
            String canbophutrach = "";
            

            //if (!String.IsNullOrEmpty(canbophutrach))
            //    canbophutrach += ", ";
            //if (ddlThamtravien.SelectedValue != "0")
            //    canbophutrach +=((string.IsNullOrEmpty(canbophutrach))?"":", " )+ "thẩm tra viên " + ddlThamtravien.SelectedItem.Text;


            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            
            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }
    }
}