using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class QLTotrinh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    check_is_ThamPhan();
                    Load_LoaiTrinh(ddlLoaitrinh, false, true);
                    Load_LoaiTrinh(dropCapTrinhTiep, true, true);
                    try
                    {
                        LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
                        LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttLanhDao);
                    }
                    catch (Exception ex) { }

                    //dropCapTrinhTiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                    //dropLDrinhTiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));



                    if (Request["vid"] != null)
                    {
                        decimal VuAnID = (string.IsNullOrEmpty(Request["vid"] + "")) ? 0 : Convert.ToDecimal(Request["vid"] + "");
                        try
                        {
                            LoadThongTinVuAn(VuAnID);
                            LoadDSToTrinh();
                        }
                        catch (Exception ex)
                        {
                            lbthongbao.Text = "Lỗi: " + ex.Message;
                            lbthongbao.ForeColor = System.Drawing.Color.Red;
                        }
                    }

                    Load_Totrinh_Top1();
                }
            }
        }
        protected void cmdThem_Click(object sender, EventArgs e)
        {
            //totrinh_thongtin.Style.Remove("Display");
        }
        void check_is_ThamPhan()
        {
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                    {
                        //----------------------
                        txtNgayLDNhanToTrinh.Focus();
                        txtSototrinh.Enabled = false;
                        txtNgaylap.Enabled = false;
                        chkEdit.Enabled = false;
                        txtDeXuatTTV.Enabled = false;
                        ddlLoaitrinh.Enabled = true;//edit = true - yêu cầu vanvt 22/08/2023 thẩm phán dunv.tatc
                        ddlLanhdao.Enabled = true;//edit = true sửa cho thẩm phán nhập - yêu cầu vanvt 22/08/2023 thẩm phán dunv.tatc
                        txtNgaytrinh.Enabled = true;
                        txtNgayDangKyBC.Enabled = true;
                        //----------------------
                        txtNgaytra.Enabled = true;
                        txtNgayLDNhanToTrinh.Enabled = true;
                        chkTrinhLai.Enabled = false;
                        chkYeuCauKhac.Enabled = true;
                        rdLoaiYKien.Enabled = true;
                        cmdHuyChon.Enabled = true;
                        cmdHuyChonTTV.Enabled = true;
                        dropCapTrinhTiep.Enabled = true;
                        dropLDrinhTiep.Enabled = true;
                        txtYkien.Enabled = true;
                        txtGhichu.Enabled = true;
                    }
                    else  //--------ttv--------------
                    {
                        txtSototrinh.Focus();
                        txtSototrinh.Enabled = true;
                        txtNgaylap.Enabled = true;
                        txtDeXuatTTV.Enabled = true;
                        ddlLoaitrinh.Enabled = true;
                        ddlLanhdao.Enabled = true;
                        txtNgaytrinh.Enabled = true;
                        chkEdit.Enabled = true;
                        txtNgayDangKyBC.Enabled = true;
                        //----------------------
                        txtNgaytra.Enabled = true;
                        txtNgayLDNhanToTrinh.Enabled = true;
                        chkTrinhLai.Enabled = true;
                        chkYeuCauKhac.Enabled = true;
                        rdLoaiYKien.Enabled = true;
                        cmdHuyChon.Enabled = true;
                        cmdHuyChonTTV.Enabled = true;
                        dropCapTrinhTiep.Enabled = true;
                        dropLDrinhTiep.Enabled = true;
                        txtYkien.Enabled = true;
                        txtGhichu.Enabled = true;
                    }
                    //else  //--------ttv--------------
                    //{
                    //    txtSototrinh.Enabled = true;
                    //    txtNgaylap.Enabled = true;
                    //    txtDeXuatTTV.Enabled = true;
                    //    ddlLoaitrinh.Enabled = true;
                    //    ddlLanhdao.Enabled = true;
                    //    txtNgaytrinh.Enabled = true;
                    //    chkEdit.Enabled = true;
                    //    txtNgayDangKyBC.Enabled = true;
                    //    //----------------------
                    //    txtNgaytra.Enabled = false;
                    //    txtNgayLDNhanToTrinh.Enabled = false;
                    //    chkTrinhLai.Enabled = false;
                    //    chkYeuCauKhac.Enabled = false;
                    //    rdLoaiYKien.Enabled = false;
                    //    cmdHuyChon.Enabled = false;
                    //    dropCapTrinhTiep.Enabled = false;
                    //    dropLDrinhTiep.Enabled = false;
                    //    txtYkien.Enabled = false;
                    //    txtGhichu.Enabled = false;
                    //}
                }

            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        //---------------------------
        void LoadThongTinVuAn(Decimal VuAnID)
        {
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    txtTenVuan.Text = oT.TENVUAN;
                else
                {
                    txtTenVuan.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oQHPL.TENQHPL;
                    }
                }
                //----------------------------------
                if (string.IsNullOrEmpty(oT.SOTOTRINH + ""))
                    SetNewSoToTrinh();
                else
                    txtSototrinh.Text = oT.SOTOTRINH + "";
                txtSototrinh.Enabled = (string.IsNullOrEmpty(oT.SOTOTRINH + "") ? true : false);


                try
                {
                    if (oT.NGAYLAPTOTRINH != null)
                        txtNgaylap.Text = ((DateTime)oT.NGAYLAPTOTRINH).ToString("dd/MM/yyyy", cul);

                    else
                        txtNgaylap.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                }
                catch (Exception ex) { }

                txtNgaylap.Enabled = (string.IsNullOrEmpty(oT.NGAYLAPTOTRINH + "") ? true : false);

                txtDeXuatTTV.Text = oT.DX_TTV + "";
                if ((txtSototrinh.Enabled) && (txtNgaylap.Enabled))
                    txtDeXuatTTV.Enabled = true;
                else txtDeXuatTTV.Enabled = false;

                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                //txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                //txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);

                if (oT.BAQD_CAPXETXU == 4)
                {
                    txtVuAn_SoBanAn.Text = oT.SO_QDGDT;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYQD + "") || (oT.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else if (oT.BAQD_CAPXETXU == 2)
                {
                    txtVuAn_SoBanAn.Text = oT.SOANSOTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUSOTHAM + "") || (oT.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);
                }

                if (oT.LOAIAN == 1)
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = true;
                    pnNguyendo.Visible = pnBidon.Visible = false;
                    txtVuAn_NguyenDon.Text = oT.NGUYENDON;
                    txtVuAn_BiDon.Text = oT.BIDON;
                }
                else
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = false;
                    pnNguyendo.Visible = pnBidon.Visible = true;
                    //----------------------------------
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                }

            }
        }
        void LoadDuongSu(Decimal VuAnID, string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
        //-------------------------------
        private void LoadDSToTrinh()
        {
            DataTable tbl = GetData();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = tbl.Rows.Count;
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
                cmdPrinDS.Visible = true;
                //-----------------
                if (String.IsNullOrEmpty(txtSototrinh.Text.Trim()))
                    txtSototrinh.Text = "(Không có số)";
                if (String.IsNullOrEmpty(txtNgaylap.Text.Trim()))
                    txtNgaylap.Text = Convert.ToDateTime(tbl.Rows[count_all - 1]["NGAYTRINH"] + "").ToString("dd/MM/yyyy", cul);
            }
            else
            {
                rpt.Visible = false;
                cmdPrinDS.Visible = false;
            }
        }
        void Load_Totrinh_Top1()
        {
            string strvid = Request["vid"] + "";
            decimal VuAnID = Convert.ToDecimal(strvid);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = oBL.VUAN_TOTRINH_TOP1(VuAnID, Convert.ToInt32(Session[SS_TK.THAMPHAN] + ""));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Load_Totrinh(Convert.ToDecimal(tbl.Rows[0]["TOTRINH_ID"]));
            }
        }
        DataTable GetData()
        {
            int count_row = 1;
            DataTable tblData = null;
            string strvid = Request["vid"] + "";
            decimal VuAnID = Convert.ToDecimal(strvid);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = oBL.VUAN_TOTRINH(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tbl.Columns.Add("IsShow", typeof(Int16));
                tbl.Columns.Add("Rowspan", typeof(Int16));
                //tbl.Columns.Add("YKienDuyetToTrinh", typeof(string));

                int lantrinh = 1, IsTrinhLai = 0;
                #region Tao du lieu cho column LanTrinh , column YKienDuyetToTrinh (Hien thi trong baocao)
                DataRow[] arr = tbl.Select("", "NgayTrinh_s asc,ID asc, IsTrinhLai asc");
                //DataRow[] arr = tbl.Select("");
                foreach (DataRow row in arr)
                {
                    IsTrinhLai = Convert.ToInt16(row["IsTrinhLai"] + "");
                    row["YKienDuyetToTrinh"] = Join_YKienDuyetTT(row) + "";
                    //----------------------------
                    //bat dau vong trinh moi
                    if (IsTrinhLai == 1)
                        lantrinh++;
                    row["LanTrinh"] = lantrinh;
                }
                #endregion

                //----------------------------
                DataView view = new DataView(tbl);
                view.Sort = "LanTrinh desc, NgayTrinh_s desc, ThuTuCapTrinh desc";
                tblData = view.ToTable();

                //----------------------------
                int count_index = 1;
                count_row = 1;
                for (int i = 1; i <= lantrinh; i++)
                {
                    count_index = 1;
                    arr = tblData.Select("LanTrinh=" + i.ToString());
                    count_row = arr.Length;
                    foreach (DataRow rowdata in arr)
                    {
                        rowdata["Rowspan"] = count_row;
                        if (count_index == 1)
                            rowdata["IsShow"] = 1;
                        else rowdata["IsShow"] = 0;
                        count_index++;
                    }
                }
            }
            return tblData;
        }
        String Join_YKienDuyetTT(DataRow row)
        {
            string temp = "", temp_join;
            String YKienDuyetTT = "";

            temp = (row["CapTrinhTiep"] + "").Trim();
            YKienDuyetTT += String.IsNullOrEmpty(temp) ? "" : "Yêu cầu: " + temp;

            //-------------------------------------
            temp = (row["YKienLanhDao"] + "").Trim();
            if (String.IsNullOrEmpty(temp))
            {
                temp = (row["YKien"] + "").Trim();
                temp_join = String.IsNullOrEmpty(temp) ? "" : "Ý kiến: " + temp;
                if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                    YKienDuyetTT += "<br/>";
                YKienDuyetTT += temp_join;
            }
            else
            {
                temp_join = "Ý kiến: <b>" + row["YKienLanhDao"] + "" + " </b>";
                if (YKienDuyetTT.Length > 0)
                    YKienDuyetTT += "<br/>";
                YKienDuyetTT += temp_join;

                temp = (row["YKien"] + "").Trim();
                YKienDuyetTT += String.IsNullOrEmpty(temp) ? "" : ", <span style='margin-left:5px;'>" + temp + "</span>";
            }
            //-------------------------------------
            temp = (row["Ghichu"] + "").Trim();
            temp_join = (String.IsNullOrEmpty(temp)) ? "" : ("Ghi chú: " + temp + "");
            if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                YKienDuyetTT += "<br/>";
            YKienDuyetTT += temp_join;

            //-------------------------------------
            temp = (row["DX_TTV"] + "").Trim();
            temp_join = (String.IsNullOrEmpty(temp)) ? "" : ("Đề xuất TTV: " + temp);
            if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                YKienDuyetTT += "<br/>";
            YKienDuyetTT += temp_join;

            //-------------------------------------
            return YKienDuyetTT;
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                string temp = "";
                //Literal lttYKien = (Literal)e.Item.FindControl("lttYKien");
                //if (String.IsNullOrEmpty(dv["YKienLanhDao"] + ""))
                //    lttYKien.Text = (String.IsNullOrEmpty(dv["YKien"] + "") ? "" : ("Ý kiến: " + dv["YKien"].ToString() + "<br/>"));
                //else
                //{
                //    lttYKien.Text = "Ý kiến: <b>" + dv["YKienLanhDao"].ToString() + " </b>";
                //    lttYKien.Text += (String.IsNullOrEmpty(dv["YKien"] + "") ? "" : ("<span style='margin-left:5px;'>" + dv["YKien"].ToString() + "<span>"));
                //    lttYKien.Text += "<br/>";
                //}
                // //<%# String.IsNullOrEmpty(Eval("YKienLanhDao")+"") ? (String.IsNullOrEmpty(Eval("YKien")+"")?"":"Ý kiến: "+Eval("YKIEN")):("Ý kiến: <b>"+Eval("YKienLanhDao")+"</b>"+ (String.IsNullOrEmpty(Eval("YKIEN")+"")? "":": "+ Eval("YKIEN")) +"<br/>")  %>

                Literal lttLanTrinh = (Literal)e.Item.FindControl("lttLanTrinh");
                if (dv["IsShow"].ToString() == "1")
                {
                    lttLanTrinh.Visible = true;
                    lttLanTrinh.Text = "<td rowspan='" + dv["Rowspan"].ToString() + "' style='text-align:center;'>" + dv["LanTrinh"].ToString() + "</td>";
                }
                else lttLanTrinh.Visible = false;

                //Literal lttDeXuaTTV = (Literal)e.Item.FindControl("lttDeXuaTTV");
                //temp = (dv["DX_TTV"] + "").Trim();
                //lttDeXuaTTV.Text = (String.IsNullOrEmpty(temp)) ? "" : ("Đề xuất TTV: " + temp );

                //Literal lttGhiChu = (Literal)e.Item.FindControl("lttGhiChu");
                //temp = (dv["Ghichu"] + "").Trim();
                //lttGhiChu.Text = (String.IsNullOrEmpty(temp)) ? "" : ("Ghi chú: " + temp+ "<br/>");
                ////----------------------
                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                ImageButton cmdEdit = (ImageButton)e.Item.FindControl("cmdEdit");
                Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                DM_DATAITEM oCD = new DM_DATAITEM();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                }
                //if (dv["LANHDAOID"].ToString() == Session[ENUM_SESSION.SESSION_CANBOID] + "")
                //{
                //    cmdEdit.Visible = true; cmdXoa.Visible = false;
                //}
                //else
                //{
                if (oCD.MA == "TPTATC")
                {
                    cmdEdit.Visible = true;
                    cmdXoa.Visible = false;//anhvh
                }
                else
                {
                    cmdEdit.Visible = true;
                    cmdXoa.Visible = true;
                }
                //}
                //int isKQGQ = Convert.ToInt16(dv["isKQGQ"]+"");
                //if (isKQGQ <3)
                //    cmdXoa.Visible = cmdEdit.Visible = false;
                //else cmdXoa.Visible = cmdEdit.Visible = true;
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ToTrinhID = Convert.ToDecimal(e.CommandArgument.ToString());
            Decimal VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            GDTTT_TOTRINH totrinh = dt.GDTTT_TOTRINH.FirstOrDefault(x => x.ID == ToTrinhID) ?? new GDTTT_TOTRINH(); //thông tin tờ trình
            DM_CANBO canbo = dt.DM_CANBO.FirstOrDefault(x => x.ID == totrinh.LANHDAOID) ?? new DM_CANBO(); //lãnh đạo của tờ trình
            DM_DATAITEM chucdanh = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == canbo.CHUCDANHID) ?? new DM_DATAITEM(); //chức danh của cán bộ thẩm phán

            //lấy ra sổ công văn chuyển của vụ giám đốc => lúc này vụ giám đốc đã thêm sổ => không cho sửa xóa kháng nghị đó
            SOPHATHANH_VUAN sph = dt.SOPHATHANH_VUAN.FirstOrDefault(x => x.VUANID == VuAnID);

            switch (e.CommandName)
            {
                case "Sua":
                    //nếu tờ trình là kháng nghị và chức danh là thẩm phán bậc 3 và vụ án có sổ phát hành
                    if (totrinh.LOAIYKIEN == 1 && chucdanh.MA == "TPBAC3" && sph != null)
                    {
                        string mess = "alert('Vụ án có ý kiến đề xuất kháng nghị này đã có số văn bản, bạn không thể sửa kháng nghị!')";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                        return;
                    }

                    lbthongbao.Text = "";
                    Load_Totrinh(ToTrinhID);
                    break;
                case "Xoa":
                    //nếu tờ trình là kháng nghị và chức danh là thẩm phán bậc 3 và vụ án có sổ phát hành
                    if (totrinh.LOAIYKIEN == 1 && chucdanh.MA == "TPBAC3" && sph != null)
                    {
                        string mess = "alert('Vụ án có ý kiến đề xuất kháng nghị này đã có số văn bản, bạn không thể xóa kháng nghị!')";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                        return;
                    }

                    Xoa_ToTrinh(ToTrinhID);
                    LoadDSToTrinh();
                    ResetControl();
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    break;
            }
        }

        void Load_Totrinh(decimal ToTrinhID)
        {
            hddid.Value = ToTrinhID.ToString();

            GDTTT_TOTRINH oT = dt.GDTTT_TOTRINH.Where(x => x.ID == ToTrinhID).FirstOrDefault();
            if (oT != null)
            {
                txtDeXuatTTV.Text = oT.DX_TTV + "";
                txtDeXuatTTV.Enabled = (string.IsNullOrEmpty(oT.DX_TTV + "") ? true : false);

                Cls_Comon.SetValueComboBox(ddlLoaitrinh, oT.TINHTRANGID);
                LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
                if (ddlLanhdao.Visible && oT.LANHDAOID > 0)
                {
                    GDTTT_VUAN oTVuan = dt.GDTTT_VUAN.Where(x => x.ID == oT.VUANID).FirstOrDefault();
                    GDTTT_DM_TINHTRANG oTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == oT.TINHTRANGID).FirstOrDefault();
                    switch (oTT.MA)
                    {
                        case "06":
                            //Tham phan
                            if (oT.LANHDAOID > 0 & oTVuan.THAMPHANID == oT.LANHDAOID)
                            {
                                Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);
                            }
                            else
                            {
                                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.LANHDAOID).FirstOrDefault();
                                ddlLanhdao.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                                Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);
                            }
                            break;
                        case "04":
                            //Phó Vụ trưởng
                            if (oT.LANHDAOID > 0 & oTVuan.LANHDAOVUID == oT.LANHDAOID)
                            {
                                Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);
                            }
                            else
                            {
                                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.LANHDAOID).FirstOrDefault();
                                ddlLanhdao.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                                Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);
                            }
                            break;
                        case "05":
                            //Vụ trưởng 
                            if (oT.LANHDAOID > 0 & oTVuan.LANHDAOVUID == oT.LANHDAOID)
                            {
                                Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);
                            }
                            else
                            {
                                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.LANHDAOID).FirstOrDefault();
                                ddlLanhdao.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                                Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);
                            }
                            break;
                        default:
                            Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);
                            break;
                    }
                }


                if (oT.NGAYTRINH != null) txtNgaytrinh.Text = ((DateTime)oT.NGAYTRINH).ToString("dd/MM/yyyy", cul);

                if (oT.NGAYTRA != null) txtNgaytra.Text = ((DateTime)oT.NGAYTRA).ToString("dd/MM/yyyy", cul);

                txtGhichu.Text = oT.GHICHU;

                //-------------------------
                if (oT.NGAYDK != null)
                    txtNgayDangKyBC.Text = ((DateTime)oT.NGAYDK).ToString("dd/MM/yyyy", cul);

                if (oT.NGAYLDNHANTOTRINH != null)
                    txtNgayLDNhanToTrinh.Text = ((DateTime)oT.NGAYLDNHANTOTRINH).ToString("dd/MM/yyyy", cul);

                dropLDrinhTiep.Visible = lttHoTenLDTiep.Visible = true;
                Load_LoaiTrinh(dropCapTrinhTiep, true, true);
                LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);

                decimal LoaiYKien = (String.IsNullOrEmpty(oT.LOAIYKIEN + "")) ? 0 : (decimal)oT.LOAIYKIEN;
                decimal LoaiYKienTTV = (String.IsNullOrEmpty(oT.LOAIYKIEN_TTV + "")) ? 0 : (decimal)oT.LOAIYKIEN;
                int LoaiYKien_Khac = (string.IsNullOrEmpty(oT.LOAIYKIEN_OTHER + "")) ? 0 : Convert.ToInt16(oT.LOAIYKIEN_OTHER);
                if (LoaiYKien_Khac == 1)
                {
                    Cls_Comon.SetValueComboBox(dropCapTrinhTiep, oT.CAPTRINHTIEP);
                    Cls_Comon.SetValueComboBox(dropLDrinhTiep, oT.TRINHTIEP_LANHDAO_ID);
                }
                if (oT.LOAIYKIEN == null)
                    rdLoaiYKien.ClearSelection();
                else
                    rdLoaiYKien.SelectedValue = LoaiYKien.ToString();

                if (oT.LOAIYKIEN_TTV == null)
                    rdLoaiYKienTTV.ClearSelection();
                else
                    rdLoaiYKienTTV.SelectedValue = LoaiYKienTTV.ToString();
                txtYkien.Text = oT.YKIEN;
            }
        }
        void Xoa_ToTrinh(decimal ToTrinhID)
        {
            GDTTT_TOTRINH oTDel = dt.GDTTT_TOTRINH.Where(x => x.ID == ToTrinhID).FirstOrDefault();
            dt.GDTTT_TOTRINH.Remove(oTDel);
            dt.SaveChanges();
            //--------------------
            Decimal VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            try
            {
                Update_VuAn();
            }
            catch (Exception ex) { }
            //----------------------------------
            dt.SaveChanges();
        }

        protected void chkEdit_CheckedChanged(object sender, EventArgs e)
        {
            if (chkEdit.Checked)
            {
                txtSototrinh.Enabled = true;
                txtNgaylap.Enabled = true;
                txtDeXuatTTV.Enabled = true;
            }
            else
            {
                txtSototrinh.Enabled = false;
                txtNgaylap.Enabled = false;
                txtDeXuatTTV.Enabled = false;
            }
        }
        protected void chkTrinhLai_CheckedChanged(object sender, EventArgs e)
        {
            if (chkTrinhLai.Checked)
            {
                txtDeXuatTTV.Enabled = true;
            }
            else txtDeXuatTTV.Enabled = false;
        }

        protected void txtNgaylap_TextChanged(object sender, EventArgs e)
        {
            SetNewSoToTrinh();
        }

        void SetNewSoToTrinh()
        {
            DateTime NgayLapTT = (String.IsNullOrEmpty(txtNgaylap.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgaylap.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            GDTTT_VUAN_BL obj = new GDTTT_VUAN_BL();
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);

            try
            {
                decimal STT = obj.GetNewSoToTrinh(PhongBanID, NgayLapTT);
                txtSototrinh.Text = STT.ToString();
            }
            catch (Exception ex) { txtSototrinh.Text = "1"; }
        }

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            String SessionName = "GDTTT_ReportPL".ToUpper();
            Session[SS_TK.TENBAOCAO] = "Danh sách tờ trình".ToUpper();
            int count_row = 1;
            DataTable tblData = null;
            string strvid = Request["vid"] + "";
            decimal VuAnID = Convert.ToDecimal(strvid);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = oBL.VUAN_TOTRINH(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tbl.Columns.Add("IsShow", typeof(Int16));
                tbl.Columns.Add("Rowspan", typeof(Int16));
                tblData = tbl.Clone();

                #region Tao du lieu cho column LanTrinh 
                int lantrinh = 1, IsTrinhLai = 0;
                DataRow[] arr = tbl.Select("", "NgayTrinh asc, IsTrinhLai asc");
                foreach (DataRow row in arr)
                {
                    IsTrinhLai = Convert.ToInt16(row["IsTrinhLai"] + "");
                    count_row++;

                    if (IsTrinhLai == 1)
                    {
                        //bat dau vong trinh moi
                        lantrinh++;
                        count_row = 1;
                    }
                    row["LanTrinh"] = lantrinh;
                    row["YKienDuyetToTrinh"] = Join_YKienDuyetTT(row) + "";
                }
                #endregion
            }
            if (tbl != null && tbl.Rows.Count > 0)
                Session[SessionName] = tbl;
        }
        protected void ddlLoaitrinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
        }

        private void ResetControl()
        {
            if (!string.IsNullOrEmpty(txtSototrinh.Text))
                txtSototrinh.Enabled = false;
            if (!string.IsNullOrEmpty(txtNgaylap.Text))
                txtNgaylap.Enabled = false;
            if (!string.IsNullOrEmpty(txtDeXuatTTV.Text))
                txtDeXuatTTV.Enabled = false;

            txtNgaytra.Text = txtNgaytrinh.Text = txtGhichu.Text = txtYkien.Text = txtNgayDangKyBC.Text = "";
            ddlLoaitrinh.SelectedIndex = 0;
            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);

            chkEdit.Checked = chkTrinhLai.Checked = false;
            hddid.Value = "0";
            pnTrinhLDTiep.Visible = false;
            dropCapTrinhTiep.SelectedIndex = 0;
            LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
            rdLoaiYKien.ClearSelection();
            rdLoaiYKienTTV.ClearSelection();
            chkYeuCauKhac.Checked = true;
            pnTrinhLDTiep.Visible = true;
        }

        public void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ResetControl();
        }
        public void cmdHuyChon_Click(object sender, EventArgs e)
        {
            rdLoaiYKien.ClearSelection();
        }
        public void cmdHuyChonTTV_Click(object sender, EventArgs e)
        {
            rdLoaiYKienTTV.ClearSelection();
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();

            try
            {
                if (txtSototrinh.Text == "")
                {
                    lbthongbao.ForeColor = System.Drawing.Color.Red;
                    lbthongbao.Text = "Bạn chưa nhập số tờ trình !";
                    txtSototrinh.Focus();
                    return;
                }
                if (txtNgaylap.Text == "")
                {
                    lbthongbao.ForeColor = System.Drawing.Color.Red;
                    lbthongbao.Text = "Bạn chưa nhập ngày lập tờ trình !";
                    txtNgaylap.Focus();
                    return;
                }

                if (txtNgaytrinh.Text == "" && txtNgayDangKyBC.Text == "")
                {
                    lbthongbao.ForeColor = System.Drawing.Color.Red;
                    lbthongbao.Text = "Bạn phải nhập ngày trình hoặc ngày đăng ký báo cáo !";
                    txtNgaytrinh.Focus();
                    return;
                }

                if (txtNgaytrinh.Text != "" && Cls_Comon.IsValidDate(txtNgaytrinh.Text) == false)
                {
                    lbthongbao.ForeColor = System.Drawing.Color.Red;
                    lbthongbao.Text = "Ngày trình chưa đúng định dạng !";
                    txtNgaytrinh.Focus();
                    return;
                }

                //if (Cls_Comon.IsValidDate(txtNgaytra.Text))
                //{
                //    if (txtYkien.Text == "")
                //    {
                //        lbthongbao.ForeColor = System.Drawing.Color.Red;
                //        lbthongbao.Text = "Bạn chưa nhập ý kiến !";
                //        txtYkien.Focus();
                //        return;
                //    }
                //}

                Update_ToTrinh();
                Update_VuAn();
                //Cls_Comon.ShowMessage(this, this.GetType(), "", "tinh trang" + oT.ISKETQUA);
                LoadDSToTrinh();
                ResetControl();
                lbthongbao.Text = "Lưu thành công!";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                //totrinh_thongtin.Style.Add("Display", "none");
            }
            catch (Exception ex)
            {
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Lỗi:" + ex.Message;
            }
        }
        void Update_ToTrinh()
        {
            string strvid = Request["vid"] + "";
            int count_totrinh = 0;
            decimal VuAnID = Convert.ToDecimal(strvid);
            //----------------------------------
            Boolean IsUpdate = false;
            GDTTT_TOTRINH oT;
            if (hddid.Value == "" || hddid.Value == "0")
            {
                oT = new GDTTT_TOTRINH();
                IsUpdate = false;
                oT.ISTRINHLAI = chkTrinhLai.Checked ? 1 : 0;
            }
            else
            {
                decimal ID = Convert.ToDecimal(hddid.Value);
                oT = dt.GDTTT_TOTRINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    IsUpdate = true;
                    if (chkTrinhLai.Checked)
                        oT.ISTRINHLAI = 1;
                }
                else
                {
                    IsUpdate = false;
                    oT = new GDTTT_TOTRINH();
                    oT.ISTRINHLAI = chkTrinhLai.Checked ? 1 : 0;
                }
            }

            //---------------------
            oT.VUANID = VuAnID;
            oT.LANHDAOID = (ddlLanhdao.Visible) ? Convert.ToDecimal(ddlLanhdao.SelectedValue) : 0;
            oT.NGAYTRINH = (String.IsNullOrEmpty(txtNgaytrinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oT.NGAYDK = (String.IsNullOrEmpty(txtNgayDangKyBC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayDangKyBC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oT.NGAYTRA = (String.IsNullOrEmpty(txtNgaytra.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            oT.YKIEN = txtYkien.Text;
            oT.GHICHU = txtGhichu.Text;
            oT.TINHTRANGID = Convert.ToDecimal(ddlLoaitrinh.SelectedValue);
            oT.ISKETQUA = (String.IsNullOrEmpty(txtNgaytra.Text)) ? 0 : 1;

            //try { count_totrinh = dt.GDTTT_TOTRINH.Where(x => x.VUANID == VuAnID).ToList().Count; } catch (Exception ex) { }

            if (chkTrinhLai.Checked || (txtDeXuatTTV.Enabled == true))
                oT.DX_TTV = txtDeXuatTTV.Text.Trim();
            //------------------------
            oT.NGAYLDNHANTOTRINH = (String.IsNullOrEmpty(txtNgayLDNhanToTrinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayLDNhanToTrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //----------------------------------
            if (rdLoaiYKien.SelectedValue != "")
            {
                oT.LOAIYKIEN = Convert.ToDecimal(rdLoaiYKien.SelectedValue);
                if (rdLoaiYKien.SelectedValue == "10")
                {
                    //Tu dong tao them mot to trinh co TinhTrangID = 10 , ngay trinh = ngay tra 
                    //Ds to trinh ko hien muc nay ra
                }
            }
            else oT.LOAIYKIEN = null;

            if (rdLoaiYKienTTV.SelectedValue != "")
            {
                oT.LOAIYKIEN_TTV = Convert.ToInt16(rdLoaiYKienTTV.SelectedValue);
            }
            else oT.LOAIYKIEN_TTV = null;

            if (dropCapTrinhTiep.SelectedValue != "0")
            {
                oT.LOAIYKIEN_OTHER = 1;
                oT.CAPTRINHTIEP = Convert.ToDecimal(dropCapTrinhTiep.SelectedValue);
                oT.TRINHTIEP_LANHDAO_ID = (!dropLDrinhTiep.Visible) ? 0 : Convert.ToDecimal(dropLDrinhTiep.SelectedValue);
            }
            else
            {
                oT.LOAIYKIEN_OTHER = 0;
                oT.CAPTRINHTIEP = 0;
                oT.TRINHTIEP_LANHDAO_ID = 0;
            }

            //------------------------------
            if (!IsUpdate)
            {
                oT.LANTRINH = 0;
                oT.DONID = 0;
                dt.GDTTT_TOTRINH.Add(oT);
                dt.SaveChanges();
            }
            else
                dt.SaveChanges();
        }
        void Update_VuAn()
        {
            decimal count_tt = 0, vuan_trangthai = 0;
            Decimal max_trangthai_tt = 0;
            String max_ghichu = "";
            string dx_ttv = "";
            decimal VuAnID = (string.IsNullOrEmpty(Request["vid"] + "")) ? 0 : Convert.ToDecimal(Request["vid"] + "");
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            if (oVA != null)
            {
                GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
                DataTable tbl = oBL.VUAN_TOTRINH(VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    count_tt = tbl.Rows.Count;
                    //max_ngaytrinh = Convert.ToDateTime(tbl.Rows[0]["NgayTrinh"] + "");
                    max_trangthai_tt = Convert.ToDecimal(tbl.Rows[0]["TinhTrangID"] + "");
                    max_ghichu = tbl.Rows[0]["Ghichu"] + "";
                    dx_ttv = tbl.Rows[0]["DX_TTV"] + "";
                    //-----------------------            
                    vuan_trangthai = (Decimal)oVA.TRANGTHAIID;
                    GDTTT_DM_TINHTRANG obTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == vuan_trangthai).Single();
                    if (obTT != null)
                    {
                        if (obTT.GIAIDOAN < 3)
                        {
                            oVA.TRANGTHAIID = max_trangthai_tt;
                            oVA.QUATRINH_GHICHU = max_ghichu;
                            oVA.DX_TTV = dx_ttv;
                        }
                    }
                }
                else
                {
                    count_tt = 0;
                    decimal TTV = (string.IsNullOrEmpty(oVA.THAMTRAVIENID + "")) ? 0 : (Decimal)oVA.THAMTRAVIENID;
                    if (TTV > 0)
                        oVA.TRANGTHAIID = 2;
                    else oVA.TRANGTHAIID = 1;
                }

                if (string.IsNullOrEmpty(oVA.SOTOTRINH + ""))
                    oVA.SOTOTRINH = txtSototrinh.Text;
                if (string.IsNullOrEmpty(oVA.NGAYLAPTOTRINH + ""))
                    oVA.NGAYLAPTOTRINH = (String.IsNullOrEmpty(txtNgaylap.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaylap.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oVA.ISTOTRINH = count_tt;
                dt.SaveChanges();

                //-----------------------------
                txtDeXuatTTV.Text = dx_ttv;

            }
        }

        //protected void rdLoaiYKien_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    int type = Convert.ToInt16(rdLoaiYKien.SelectedValue);
        //    if (type == 2)
        //    {
        //        pnTrinhLDTiep.Visible = true;
        //        dropLDrinhTiep.Visible = lttHoTenLDTiep.Visible = true;

        //        Load_LoaiTrinh(dropCapTrinhTiep, true);
        //        LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
        //    }
        //    else pnTrinhLDTiep.Visible = false;
        //}
        protected void chkYeuCauKhac_CheckedChanged(object sender, EventArgs e)
        {
            if (chkYeuCauKhac.Checked)
            {
                pnTrinhLDTiep.Visible = true;
                dropLDrinhTiep.Visible = lttHoTenLDTiep.Visible = true;

                Load_LoaiTrinh(dropCapTrinhTiep, true, false);
                LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
            }
            else
            {
                pnTrinhLDTiep.Visible = false;
                dropLDrinhTiep.Visible = lttHoTenLDTiep.Visible = false;
                dropCapTrinhTiep.Items.Clear();
                dropCapTrinhTiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                dropLDrinhTiep.Items.Clear();
                dropLDrinhTiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }
        protected void dropCapTrinhTiep_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
        }

        //---------------------------------
        void Load_LoaiTrinh(DropDownList drop, Boolean ShowChangeAll, Boolean ShowNghienCuuBS)
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + ""); drop.Items.Clear();
            List<GDTTT_DM_TINHTRANG> lst = null;
            if (ShowNghienCuuBS)
                lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.GIAIDOAN == 2
                                                    && x.ID != 100
                                                    && x.HIEULUC == 1).OrderBy(x => x.THUTU).ToList();
            else
                lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.GIAIDOAN == 2
                                                    && x.ID != 100 && x.ID != 10
                                                    && x.HIEULUC == 1).OrderBy(x => x.THUTU).ToList();

            String Name_Phongban = "";
            DM_PHONGBAN PB_NAME = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
            if(PB_NAME != null)
            {
                Name_Phongban = PB_NAME.TENPHONGBAN;
            }    
            //add check tên tình trạng
            foreach (GDTTT_DM_TINHTRANG it in lst)
            {
                if(Name_Phongban.ToLower().Contains("vụ giám đốc") && Name_Phongban.ToLower().Contains("kiểm tra"))//vụ giám đốc kiểm tra
                {
                    if (it.ID == 5)
                    {
                        it.TENTINHTRANG = "Trình Vụ Trưởng";
                    }
                    if (it.ID == 4)
                    {
                        it.TENTINHTRANG = "Trình Phó Vụ Trưởng";
                    }
                }
                else 
                {
                    if (it.ID == 5)//Trình Vụ Trưởng
                    {
                        it.TENTINHTRANG = "Trình trưởng phòng";
                    }
                    if (it.ID == 4)//Trình Phó Vụ Trưởng
                    {
                        it.TENTINHTRANG = "Phó Trưởng phòng";
                    }
                }
            }
            drop.DataSource = lst;
            drop.DataTextField = "TENTINHTRANG";
            drop.DataValueField = "ID";
            drop.DataBind();
            if (ShowChangeAll)
                drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        private void LoadLanhdao(DropDownList dropCapTrinh, DropDownList dropLanhDao, Literal lttHoTen)
        {
            decimal TrangThaiID = Convert.ToDecimal(dropCapTrinh.SelectedValue);
            string v_chanhan = "";
            dropLanhDao.Items.Clear();
            if (TrangThaiID > 0)
            {
                lttHoTen.Visible = true;
                dropLanhDao.Visible = true;
                GDTTT_DON_BL objDon = new GDTTT_DON_BL();
                DM_CANBO_BL objCB = new DM_CANBO_BL();

                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
                decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                GDTTT_DM_TINHTRANG oTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == TrangThaiID).FirstOrDefault();
                dropLanhDao.Items.Clear();
                String Name_Phongban = "";
                DM_PHONGBAN PB_NAME = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
                switch (oTT.MA)
                {
                    case "13"://Trinh du thao KN
                        lttHoTen.Text = "Lãnh đạo";
                        DataTable oCAPCA_KN = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_PCA);
                        dropLanhDao.DataSource = oCAPCA_KN;
                        dropLanhDao.DataTextField = "MA_TEN";
                        dropLanhDao.DataValueField = "ID";
                        dropLanhDao.DataBind();

                        DataTable oCACA_KN = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_CA);
                        foreach (DataRow row in oCACA_KN.Rows)
                        {
                            dropLanhDao.Items.Insert(0, new ListItem(row["MA_TEN"].ToString(), row["ID"].ToString()));

                        }

                        DataTable oCATP1_KN = objCB.DM_CANBO_GETBYDONVI_CHUCDANH(DonViID, "TPTATC");
                        foreach (DataRow row in oCATP1_KN.Rows)
                        {
                            if (row["CHUCVU"].ToString() == "")
                            {
                                dropLanhDao.Items.Insert(0, new ListItem(row["MA_TEN"].ToString(), row["ID"].ToString()));
                            }
                        }

                        dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "12"://Trinh du thao TLD
                        lttHoTen.Text = "Lãnh đạo";
                        DataTable oCAPCA1 = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_PCA);
                        dropLanhDao.DataSource = oCAPCA1;
                        dropLanhDao.DataTextField = "MA_TEN";
                        dropLanhDao.DataValueField = "ID";
                        dropLanhDao.DataBind();

                        DataTable oCACA1_KN = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_CA);
                        foreach (DataRow row in oCACA1_KN.Rows)
                        {
                            dropLanhDao.Items.Insert(0, new ListItem(row["MA_TEN"].ToString(), row["ID"].ToString()));

                        }

                        DataTable oCATP_KN = objCB.DM_CANBO_GETBYDONVI_CHUCDANH(DonViID, "TPTATC");
                        foreach (DataRow row in oCATP_KN.Rows)
                        {
                            if (row["CHUCVU"].ToString() == "")
                            {
                                dropLanhDao.Items.Insert(0, new ListItem(row["MA_TEN"].ToString(), row["ID"].ToString()));
                            }

                        }
                        dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "07"://Phó chánh án
                        lttHoTen.Text = "Phó chánh án";
                        DataTable oCAPCA = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_PCA);
                        dropLanhDao.DataSource = oCAPCA;
                        dropLanhDao.DataTextField = "MA_TEN";
                        dropLanhDao.DataValueField = "ID";
                        dropLanhDao.DataBind();
                        break;
                    case "06":
                        //Tham phan
                        lttHoTen.Text = "Thẩm phán";

                        var ctc = dt.GDTTT_VUAN_CHITIET_CHUYEN.FirstOrDefault(x => x.VUANID == oT.ID && x.TRANGTHAICHUYENTP == 1); //đã chuyển thẩm phán
                        if (ctc != null)
                        {
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == ctc.THAMPHANID).FirstOrDefault();
                            if (oCB != null)
                                dropLanhDao.Items.Insert(dropLanhDao.Items.Count, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        }
                        if (oT.THAMPHANID > 0)
                        {
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
                            if (oCB != null)
                                dropLanhDao.Items.Insert(dropLanhDao.Items.Count, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        }
                        if (dropLanhDao.Items.Count == 0)
                            dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "04":
                        //Phó Vụ trưởng
                        Name_Phongban = "";
                        if (PB_NAME != null)
                        {
                            Name_Phongban = PB_NAME.TENPHONGBAN;
                        }
                        if (Name_Phongban.ToLower().Contains("vụ giám đốc") && Name_Phongban.ToLower().Contains("kiểm tra"))//vụ giám đốc kiểm tra
                        {
                            lttHoTen.Text = "Phó Vụ trưởng";
                        }
                        else
                        {
                            lttHoTen.Text = "Phó Trưởng phòng";
                        }

                        if (oT.LANHDAOVUID > 0)
                        {
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oT.LANHDAOVUID).FirstOrDefault();
                            dropLanhDao.Items.Insert(0, new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        }
                        else
                            dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    case "05":

                        DataTable tblVT = new DataTable();
                        //Vụ trưởng
                        lttHoTen.Text = "Vụ trưởng";
                        Name_Phongban = "";
                        if (PB_NAME != null)
                        {
                            Name_Phongban = PB_NAME.TENPHONGBAN;
                        }
                        if (Name_Phongban.ToLower().Contains("vụ giám đốc") && Name_Phongban.ToLower().Contains("kiểm tra"))//vụ giám đốc kiểm tra
                        {
                            lttHoTen.Text = "Vụ trưởng";
                            tblVT = objDon.CANBO_GETBYDONVI_2CHUCVU(DonViID, PBID, ENUM_CHUCVU.CHUCVU_VT, ENUM_CHUCVU.CHUCVU_VT);
                        }
                        else
                        {
                            lttHoTen.Text = "Trưởng phòng";
                            tblVT = objDon.CANBO_GETBYDONVI_LANHDAO(DonViID, PBID, ",041,");
                        }

                        
                        dropLanhDao.DataSource = tblVT;
                        dropLanhDao.DataTextField = "MA_TEN";
                        dropLanhDao.DataValueField = "ID";
                        dropLanhDao.DataBind();
                        if (dropLanhDao.Items.Count == 0)
                            dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
                        break;
                    default:
                        lttHoTen.Visible = false;
                        dropLanhDao.Visible = false;
                        break;
                }
            }
            else
            {
                dropLanhDao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                lttHoTen.Text = "Lãnh đạo";
            }
        }
        //---------------------------------
    }
}