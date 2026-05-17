using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP;
using BL.GSTP.ADS;
using DAL.GSTP;
using Module.Common;
using System.Data;
using System.Globalization;
using System.IO;

namespace WEB.GSTP.QLAN.DONGHEP
{
    public partial class PopupXuLyDon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnNDBD.Visible = false;
                txtNguoidungdon.Visible = false;
                txtNguoikhangcao.Visible = false;
                txtNguoiyeucau.Visible = false;
                txtYCBS.Visible = true;
                lbNguoiyeucau.Visible = false;
                lbNguoikhangcao.Visible = false;
                lbNguoidungdon.Visible = false;
                //lbLDTL.Visible = false;
                //lbYCBS.Visible = false;
                //txtTCTT.Enabled = true;

                pnAnDSChung.Visible = false;
                pnAnHS.Visible = false;

                decimal DONGHEPID = Convert.ToDecimal(Request.QueryString["DONGHEPID"]);
                decimal LOAIDON = Convert.ToDecimal(Request.QueryString["LOAIDON"]);
                decimal LOAIAN = Convert.ToDecimal(Request.QueryString["LOAIAN"]);

                if (LOAIAN == 1)
                {
                    pnAnHS.Visible = true;
                    pnAnDSChung.Visible = false;
                }
                else
                {
                    pnAnHS.Visible = false;
                    pnAnDSChung.Visible = true;
                }

                if (LOAIAN != 3)
                {
                    ddlLoaidon.SelectedValue = LOAIDON.ToString();
                    ddlLoaidon.Enabled = false;
                    ddlLoaidonHN.Visible = false;
                }
                else
                {
                    ddlLoaidonHN.SelectedValue = LOAIDON.ToString();
                    ddlLoaidonHN.Enabled = false;
                    ddlLoaidon.Visible = false;
                }
                txtQHPL.Enabled = false;
                txtNguoidungdon.Enabled = false;
                txtNguoikhangcao.Enabled = false;
                txtNguoiyeucau.Enabled = false;
                txtTenbidon.Enabled = false;
                txtTennguyendon.Enabled = false;
                txtCMND_ND.Enabled = false;
                txtCMND_BD.Enabled = false;
                txtTCTT.Enabled = false;


                if (LOAIAN == 1)
                {
                    DON_KHAC oLoadDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //if (oLoadDK.TTGQ != null)
                    //{
                    //rdTTGQ.SelectedValue = oLoadDK.TTGQ.ToString();
                    txtYCBS.Text = oLoadDK.NOIDUNGTTGQ;
                    //    if (oLoadDK.TTGQ == 2)
                    //    {
                    //        txtYCBS.Visible = true;
                    //        //lbYCBS.Visible = true;
                    //    }
                    //    if (oLoadDK.TTGQ == 3)
                    //    {
                    //        txtYCBS.Visible = true;
                    //        //lbLDTL.Visible = true;
                    //    }
                    //}
                    //else
                    //{
                    //    //rdTTGQ.SelectedValue = "1";
                    //}

                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                    AHS_VUAN oD = dt.AHS_VUAN.Where(x => x.ID == donid).FirstOrDefault();
                    if (oLoadDK.ISDUONGSU == 0)
                    {
                        AHS_NGUOITHAMGIATOTUNG oTCTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == oLoadDK.DUONGSUID).FirstOrDefault();
                        AHS_NGUOITHAMGIATOTUNG_TUCACH oTCTT_TUCACH = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == oLoadDK.DUONGSUID).FirstOrDefault();
                        DM_DATAITEM TenTuCach = dt.DM_DATAITEM.Where(x => x.ID == oTCTT_TUCACH.TUCACHID).FirstOrDefault();
                        txtTCTT.Text = TenTuCach.TEN;
                        if (LOAIDON == 7)
                        {
                            txtNguoikhangcao.Text = oTCTT.HOTEN;
                        }
                        else if (LOAIDON == 8)
                        {
                            txtNguoidungdon.Text = oTCTT.HOTEN;

                        }
                    }
                    else if (oLoadDK.ISDUONGSU == 1)
                    {
                        AHS_BICANBICAO oBiCan = dt.AHS_BICANBICAO.Where(x => x.ID == oLoadDK.DUONGSUID).FirstOrDefault();
                        txtTCTT.Text = "Bị can, bị cáo";
                        if (LOAIDON == 7)
                        {
                            txtNguoikhangcao.Text = oBiCan.HOTEN;
                        }
                        else if (LOAIDON == 8)
                        {
                            txtNguoidungdon.Text = oBiCan.HOTEN;

                        }
                    }
                }
                else if (LOAIAN == 2)
                {
                    //if (LOAIDON != 7 && LOAIDON != 8)
                    //{
                    //    DON_CHITIET oLoadCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN ).FirstOrDefault();
                    //    if (oLoadCT.TTGQ != null)
                    //    {
                    //        //rdTTGQ.SelectedValue = oLoadCT.TTGQ.ToString();
                    //        txtYCBS.Text = oLoadCT.NOIDUNGTTGQ;
                    //        if(oLoadCT.TTGQ == 2)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbYCBS.Visible = true;
                    //        }
                    //        if (oLoadCT.TTGQ == 3)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbLDTL.Visible = true;
                    //        }
                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    //else
                    //{
                    DON_KHAC oLoadDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //if (oLoadDK.TTGQ != null)
                    //{
                    //rdTTGQ.SelectedValue = oLoadDK.TTGQ.ToString();
                    txtYCBS.Text = oLoadDK.NOIDUNGTTGQ;
                    //if (oLoadDK.TTGQ == 2)
                    //{
                    //    txtYCBS.Visible = true;
                    //    //lbYCBS.Visible = true;
                    //}
                    //if (oLoadDK.TTGQ == 3)
                    //{
                    //    txtYCBS.Visible = true;
                    //    //lbLDTL.Visible = true;
                    //}
                    //}
                    //else
                    //{
                    //    //rdTTGQ.SelectedValue = "1";
                    //}
                    //}

                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);
                    ADS_DON oD = dt.ADS_DON.Where(x => x.ID == donid).FirstOrDefault();
                    if (oD.QUANHEPHAPLUAT_NAME != null)
                    {
                        txtQHPL.Text = oD.QUANHEPHAPLUAT_NAME;
                    }
                    else if (oD.QUANHEPHAPLUATID != null && oD.QUANHEPHAPLUATID != 0)
                    {
                        decimal IDQHPL = Convert.ToDecimal(oD.QUANHEPHAPLUATID.ToString());
                        DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                        if (obj != null)
                            txtQHPL.Text = obj.TEN.ToString();
                    }
                    else
                        txtQHPL.Text = null;

                    if (LOAIDON == 1 || LOAIDON == 2 || LOAIDON == 3 || LOAIDON == 4)
                    {
                        ADS_DON_DUONGSU oND = null;
                        ADS_DON_DUONGSU oBD = null;
                        List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == DONGHEPID).ToList();
                        for (int i = 0; i < oListDs.Count; i++)
                        {
                            int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                            ADS_DON_DUONGSU Ods = dt.ADS_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            if (Ods.TUCACHTOTUNG_MA == "NGUYENDON")
                            {
                                oND = dt.ADS_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                            if (Ods.TUCACHTOTUNG_MA == "BIDON")
                            {
                                oBD = dt.ADS_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                        }
                        if (oListDs.Count > 0)
                        {
                            if (oND != null)
                            {
                                txtTennguyendon.Text = oND.TENDUONGSU;
                                txtCMND_ND.Text = oND.SOCMND;
                            }
                            if (oBD != null)
                            {
                                txtTenbidon.Text = oBD.TENDUONGSU;
                                txtCMND_BD.Text = oBD.SOCMND;
                            }


                        }
                    }
                    else if (LOAIDON == 5 || LOAIDON == 6)
                    {
                        string NguoiYeuCau = "";
                        try
                        {
                            var data = (from s in dt.DON_DUONGSU_CHITIET
                                        join d in dt.ADS_DON_DUONGSU on s.DUONGSUID equals d.ID
                                        where s.DONCHITIETID == DONGHEPID
                                        select new
                                        {
                                            d.TENDUONGSU
                                        });
                            foreach (var item in data)
                            {
                                NguoiYeuCau = NguoiYeuCau + " " + item.TENDUONGSU + ",";
                            }
                            txtNguoiyeucau.Text = NguoiYeuCau.TrimEnd(',');
                        }
                        catch { }
                    }
                    //else if (LOAIDON == 7)
                    //{
                    //    DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //    if (oDK != null)
                    //    {
                    //        if (oDK.ISDUONGSU == 1)
                    //        {
                    //            ADS_DON_DUONGSU oDKDS = dt.ADS_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                    //            txtNguoikhangcao.Text = oDKDS.TENDUONGSU;
                    //        }
                    //        else if (oDK.ISDUONGSU == 0)
                    //        {
                    //            ADS_DON_THAMGIATOTUNG oDKTGTT = dt.ADS_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                    //            txtNguoikhangcao.Text = oDKTGTT.HOTEN;
                    //        }
                    //    }

                    //}
                    else if (LOAIDON == 8)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                ADS_DON_DUONGSU oDKDS = dt.ADS_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                ADS_DON_THAMGIATOTUNG oDKTGTT = dt.ADS_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKTGTT.HOTEN;
                            }
                        }
                    }
                }
                else if (LOAIAN == 3)
                {
                    //if (LOAIDON != 10 && LOAIDON != 11)
                    //{
                    //    DON_CHITIET oLoadCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //    if (oLoadCT.TTGQ != null)
                    //    {
                    //        //rdTTGQ.SelectedValue = oLoadCT.TTGQ.ToString();
                    //        txtYCBS.Text = oLoadCT.NOIDUNGTTGQ;
                    //        if (oLoadCT.TTGQ == 2)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbYCBS.Visible = true;
                    //        }
                    //        if (oLoadCT.TTGQ == 3)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbLDTL.Visible = true;
                    //        }
                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    //else
                    //{
                    DON_KHAC oLoadDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //if (oLoadDK.TTGQ != null)
                    //{
                    //rdTTGQ.SelectedValue = oLoadDK.TTGQ.ToString();
                    txtYCBS.Text = oLoadDK.NOIDUNGTTGQ;
                    //if (oLoadDK.TTGQ == 2)
                    //{
                    //    txtYCBS.Visible = true;
                    //    //lbYCBS.Visible = true;
                    //}
                    //if (oLoadDK.TTGQ == 3)
                    //{
                    //    txtYCBS.Visible = true;
                    //    //lbLDTL.Visible = true;
                    //}

                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                    AHN_DON oD = dt.AHN_DON.Where(x => x.ID == donid).FirstOrDefault();
                    if (oD.QUANHEPHAPLUAT_NAME != null)
                    {
                        txtQHPL.Text = oD.QUANHEPHAPLUAT_NAME;
                    }
                    else if (oD.QUANHEPHAPLUATID != null && oD.QUANHEPHAPLUATID != 0)
                    {
                        decimal IDQHPL = Convert.ToDecimal(oD.QUANHEPHAPLUATID.ToString());
                        DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                        if (obj != null)
                            txtQHPL.Text = obj.TEN.ToString();
                    }
                    else
                        txtQHPL.Text = null;

                    if (LOAIDON == 1 || LOAIDON == 2 || LOAIDON == 3 || LOAIDON == 4 || LOAIDON == 5 || LOAIDON == 6 || LOAIDON == 7)
                    {
                        AHN_DON_DUONGSU oND = null;
                        AHN_DON_DUONGSU oBD = null;
                        List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == DONGHEPID).ToList();
                        for (int i = 0; i < oListDs.Count; i++)
                        {
                            int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                            AHN_DON_DUONGSU Ods = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            if (Ods.TUCACHTOTUNG_MA == "NGUYENDON")
                            {
                                oND = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                            if (Ods.TUCACHTOTUNG_MA == "BIDON")
                            {
                                oBD = dt.AHN_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                        }
                        if (oListDs.Count > 0)
                        {
                            if (oND != null)
                            {
                                txtTennguyendon.Text = oND.TENDUONGSU;
                                txtCMND_ND.Text = oND.SOCMND;
                            }
                            if (oBD != null)
                            {
                                txtTenbidon.Text = oBD.TENDUONGSU;
                                txtCMND_BD.Text = oBD.SOCMND;
                            }


                        }
                    }
                    else if (LOAIDON == 8 || LOAIDON == 9)
                    {
                        string NguoiYeuCau = "";
                        try
                        {
                            var data = (from s in dt.DON_DUONGSU_CHITIET
                                        join d in dt.AHN_DON_DUONGSU on s.DUONGSUID equals d.ID
                                        where s.DONCHITIETID == DONGHEPID
                                        select new
                                        {
                                            d.TENDUONGSU
                                        });
                            foreach (var item in data)
                            {
                                NguoiYeuCau = NguoiYeuCau + " " + item.TENDUONGSU + ",";
                            }
                            txtNguoiyeucau.Text = NguoiYeuCau.TrimEnd(',');
                        }
                        catch { }
                    }
                    else if (LOAIDON == 10)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                AHN_DON_DUONGSU oDKDS = dt.AHN_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                AHN_DON_THAMGIATOTUNG oDKTGTT = dt.AHN_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKTGTT.HOTEN;
                            }
                        }

                    }
                    else if (LOAIDON == 11)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                AHN_DON_DUONGSU oDKDS = dt.AHN_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                AHN_DON_THAMGIATOTUNG oDKTGTT = dt.AHN_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKTGTT.HOTEN;
                            }
                        }
                    }
                }
                else if (LOAIAN == 4)
                {
                    //if (LOAIDON != 7 && LOAIDON != 8)
                    //{
                    //    DON_CHITIET oLoadCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //    if (oLoadCT.TTGQ != null)
                    //    {
                    //        //rdTTGQ.SelectedValue = oLoadCT.TTGQ.ToString();
                    //        txtYCBS.Text = oLoadCT.NOIDUNGTTGQ;
                    //        if (oLoadCT.TTGQ == 2)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbYCBS.Visible = true;
                    //        }
                    //        if (oLoadCT.TTGQ == 3)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbLDTL.Visible = true;
                    //        }
                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    //else
                    //{
                    DON_KHAC oLoadDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //if (oLoadDK.TTGQ != null)
                    //{
                    //rdTTGQ.SelectedValue = oLoadDK.TTGQ.ToString();
                    txtYCBS.Text = oLoadDK.NOIDUNGTTGQ;
                    //if (oLoadDK.TTGQ == 2)
                    //{
                    //    txtYCBS.Visible = true;
                    //    //lbYCBS.Visible = true;
                    //}
                    //if (oLoadDK.TTGQ == 3)
                    //{
                    //    txtYCBS.Visible = true;
                    //    //lbLDTL.Visible = true;
                    //}

                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                    AKT_DON oD = dt.AKT_DON.Where(x => x.ID == donid).FirstOrDefault();
                    if (oD.QUANHEPHAPLUAT_NAME != null)
                    {
                        txtQHPL.Text = oD.QUANHEPHAPLUAT_NAME;
                    }
                    else if (oD.QUANHEPHAPLUATID != null && oD.QUANHEPHAPLUATID != 0)
                    {
                        decimal IDQHPL = Convert.ToDecimal(oD.QUANHEPHAPLUATID.ToString());
                        DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                        if (obj != null)
                            txtQHPL.Text = obj.TEN.ToString();
                    }
                    else
                        txtQHPL.Text = null;
                    if (LOAIDON == 1 || LOAIDON == 2 || LOAIDON == 3 || LOAIDON == 4)
                    {
                        AKT_DON_DUONGSU oND = null;
                        AKT_DON_DUONGSU oBD = null;
                        List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == DONGHEPID).ToList();
                        for (int i = 0; i < oListDs.Count; i++)
                        {
                            int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                            AKT_DON_DUONGSU Ods = dt.AKT_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            if (Ods.TUCACHTOTUNG_MA == "NGUYENDON")
                            {
                                oND = dt.AKT_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                            if (Ods.TUCACHTOTUNG_MA == "BIDON")
                            {
                                oBD = dt.AKT_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                        }
                        if (oListDs.Count > 0)
                        {
                            if (oND != null)
                            {
                                txtTennguyendon.Text = oND.TENDUONGSU;
                                txtCMND_ND.Text = oND.SOCMND;
                            }
                            if (oBD != null)
                            {
                                txtTenbidon.Text = oBD.TENDUONGSU;
                                txtCMND_BD.Text = oBD.SOCMND;
                            }


                        }
                    }
                    else if (LOAIDON == 5 || LOAIDON == 6)
                    {
                        string NguoiYeuCau = "";
                        try
                        {
                            var data = (from s in dt.DON_DUONGSU_CHITIET
                                        join d in dt.AKT_DON_DUONGSU on s.DUONGSUID equals d.ID
                                        where s.DONCHITIETID == DONGHEPID
                                        select new
                                        {
                                            d.TENDUONGSU
                                        });
                            foreach (var item in data)
                            {
                                NguoiYeuCau = NguoiYeuCau + " " + item.TENDUONGSU + ",";
                            }
                            txtNguoiyeucau.Text = NguoiYeuCau.TrimEnd(',');
                        }
                        catch { }
                    }
                    else if (LOAIDON == 7)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                AKT_DON_DUONGSU oDKDS = dt.AKT_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                AKT_DON_THAMGIATOTUNG oDKTGTT = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKTGTT.HOTEN;
                            }
                        }

                    }
                    else if (LOAIDON == 8)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                AKT_DON_DUONGSU oDKDS = dt.AKT_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                AKT_DON_THAMGIATOTUNG oDKTGTT = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKTGTT.HOTEN;
                            }
                        }
                    }
                }
                else if (LOAIAN == 5)
                {
                    //if (LOAIDON != 7 && LOAIDON != 8)
                    //{
                    //    DON_CHITIET oLoadCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //    if (oLoadCT.TTGQ != null)
                    //    {
                    //        //rdTTGQ.SelectedValue = oLoadCT.TTGQ.ToString();
                    //        txtYCBS.Text = oLoadCT.NOIDUNGTTGQ;
                    //        if (oLoadCT.TTGQ == 2)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbYCBS.Visible = true;
                    //        }
                    //        if (oLoadCT.TTGQ == 3)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbLDTL.Visible = true;
                    //        }
                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    //else
                    //{
                    DON_KHAC oLoadDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //if (oLoadDK.TTGQ != null)
                    //{
                    //rdTTGQ.SelectedValue = oLoadDK.TTGQ.ToString();
                    txtYCBS.Text = oLoadDK.NOIDUNGTTGQ;
                    //        if (oLoadDK.TTGQ == 2)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbYCBS.Visible = true;
                    //        }
                    //        if (oLoadDK.TTGQ == 3)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbLDTL.Visible = true;
                    //        }

                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
                    ALD_DON oD = dt.ALD_DON.Where(x => x.ID == donid).FirstOrDefault();
                    if (oD.QUANHEPHAPLUAT_NAME != null)
                    {
                        txtQHPL.Text = oD.QUANHEPHAPLUAT_NAME;
                    }
                    else if (oD.QUANHEPHAPLUATID != null && oD.QUANHEPHAPLUATID != 0)
                    {
                        decimal IDQHPL = Convert.ToDecimal(oD.QUANHEPHAPLUATID.ToString());
                        DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                        if (obj != null)
                            txtQHPL.Text = obj.TEN.ToString();
                    }
                    else
                        txtQHPL.Text = null;
                    if (LOAIDON == 1 || LOAIDON == 2 || LOAIDON == 3 || LOAIDON == 4)
                    {
                        ALD_DON_DUONGSU oND = null;
                        ALD_DON_DUONGSU oBD = null;
                        List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == DONGHEPID).ToList();
                        for (int i = 0; i < oListDs.Count; i++)
                        {
                            int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                            ALD_DON_DUONGSU Ods = dt.ALD_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            if (Ods.TUCACHTOTUNG_MA == "NGUYENDON")
                            {
                                oND = dt.ALD_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                            if (Ods.TUCACHTOTUNG_MA == "BIDON")
                            {
                                oBD = dt.ALD_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                        }
                        if (oListDs.Count > 0)
                        {
                            if (oND != null)
                            {
                                txtTennguyendon.Text = oND.TENDUONGSU;
                                txtCMND_ND.Text = oND.SOCMND;
                            }
                            if (oBD != null)
                            {
                                txtTenbidon.Text = oBD.TENDUONGSU;
                                txtCMND_BD.Text = oBD.SOCMND;
                            }


                        }
                    }
                    else if (LOAIDON == 5 || LOAIDON == 6)
                    {
                        string NguoiYeuCau = "";
                        try
                        {
                            var data = (from s in dt.DON_DUONGSU_CHITIET
                                        join d in dt.ALD_DON_DUONGSU on s.DUONGSUID equals d.ID
                                        where s.DONCHITIETID == DONGHEPID
                                        select new
                                        {
                                            d.TENDUONGSU
                                        });
                            foreach (var item in data)
                            {
                                NguoiYeuCau = NguoiYeuCau + " " + item.TENDUONGSU + ",";
                            }
                            txtNguoiyeucau.Text = NguoiYeuCau.TrimEnd(',');
                        }
                        catch { }
                    }
                    else if (LOAIDON == 7)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                ALD_DON_DUONGSU oDKDS = dt.ALD_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                ALD_DON_THAMGIATOTUNG oDKTGTT = dt.ALD_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKTGTT.HOTEN;
                            }
                        }

                    }
                    else if (LOAIDON == 8)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                ALD_DON_DUONGSU oDKDS = dt.ALD_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                ALD_DON_THAMGIATOTUNG oDKTGTT = dt.ALD_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKTGTT.HOTEN;
                            }
                        }
                    }
                }
                else if (LOAIAN == 6)
                {
                    if (LOAIDON != 7 && LOAIDON != 8)
                    {
                        DON_CHITIET oLoadCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oLoadCT.TTGQ != null)
                        {
                            //rdTTGQ.SelectedValue = oLoadCT.TTGQ.ToString();
                            txtYCBS.Text = oLoadCT.NOIDUNGTTGQ;
                            if (oLoadCT.TTGQ == 2)
                            {
                                txtYCBS.Visible = true;
                                //lbYCBS.Visible = true;
                            }
                            if (oLoadCT.TTGQ == 3)
                            {
                                txtYCBS.Visible = true;
                                //lbLDTL.Visible = true;
                            }
                        }
                        else
                        {
                            //rdTTGQ.SelectedValue = "1";
                        }
                    }
                    else
                    {
                        DON_KHAC oLoadDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oLoadDK.TTGQ != null)
                        {
                            //rdTTGQ.SelectedValue = oLoadDK.TTGQ.ToString();
                            txtYCBS.Text = oLoadDK.NOIDUNGTTGQ;
                            if (oLoadDK.TTGQ == 2)
                            {
                                txtYCBS.Visible = true;
                                //lbYCBS.Visible = true;
                            }
                            if (oLoadDK.TTGQ == 3)
                            {
                                txtYCBS.Visible = true;
                                //lbLDTL.Visible = true;
                            }

                        }
                        else
                        {
                            //rdTTGQ.SelectedValue = "1";
                        }
                    }
                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
                    AHC_DON oD = dt.AHC_DON.Where(x => x.ID == donid).FirstOrDefault();
                    if (oD.QUANHEPHAPLUAT_NAME != null)
                    {
                        txtQHPL.Text = oD.QUANHEPHAPLUAT_NAME;
                    }
                    else if (oD.QUANHEPHAPLUATID != null && oD.QUANHEPHAPLUATID != 0)
                    {
                        decimal IDQHPL = Convert.ToDecimal(oD.QUANHEPHAPLUATID.ToString());
                        DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                        if (obj != null)
                            txtQHPL.Text = obj.TEN.ToString();
                    }
                    else
                        txtQHPL.Text = null;

                    if (LOAIDON == 1 || LOAIDON == 2 || LOAIDON == 3 || LOAIDON == 4)
                    {
                        AHC_DON_DUONGSU oND = null;
                        AHC_DON_DUONGSU oBD = null;
                        List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == DONGHEPID).ToList();
                        for (int i = 0; i < oListDs.Count; i++)
                        {
                            int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                            AHC_DON_DUONGSU Ods = dt.AHC_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            if (Ods.TUCACHTOTUNG_MA == "NGUYENDON")
                            {
                                oND = dt.AHC_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                            if (Ods.TUCACHTOTUNG_MA == "BIDON")
                            {
                                oBD = dt.AHC_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                        }
                        if (oListDs.Count > 0)
                        {
                            if (oND != null)
                            {
                                txtTennguyendon.Text = oND.TENDUONGSU;
                                txtCMND_ND.Text = oND.SOCMND;
                            }
                            if (oBD != null)
                            {
                                txtTenbidon.Text = oBD.TENDUONGSU;
                                txtCMND_BD.Text = oBD.SOCMND;
                            }


                        }
                    }
                    else if (LOAIDON == 5 || LOAIDON == 6)
                    {
                        string NguoiYeuCau = "";
                        try
                        {
                            var data = (from s in dt.DON_DUONGSU_CHITIET
                                        join d in dt.AHC_DON_DUONGSU on s.DUONGSUID equals d.ID
                                        where s.DONCHITIETID == DONGHEPID
                                        select new
                                        {
                                            d.TENDUONGSU
                                        });
                            foreach (var item in data)
                            {
                                NguoiYeuCau = NguoiYeuCau + " " + item.TENDUONGSU + ",";
                            }
                            txtNguoiyeucau.Text = NguoiYeuCau.TrimEnd(',');
                        }
                        catch { }
                    }
                    else if (LOAIDON == 7)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                AHC_DON_DUONGSU oDKDS = dt.AHC_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                AHC_DON_THAMGIATOTUNG oDKTGTT = dt.AHC_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKTGTT.HOTEN;
                            }
                        }

                    }
                    else if (LOAIDON == 8)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                AHC_DON_DUONGSU oDKDS = dt.AHC_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                AHC_DON_THAMGIATOTUNG oDKTGTT = dt.AHC_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKTGTT.HOTEN;
                            }
                        }
                    }
                }
                else if (LOAIAN == 7)
                {
                    //if (LOAIDON != 7 && LOAIDON != 8)
                    //{
                    //    DON_CHITIET oLoadCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //    if (oLoadCT.TTGQ != null)
                    //    {
                    //        //rdTTGQ.SelectedValue = oLoadCT.TTGQ.ToString();
                    //        txtYCBS.Text = oLoadCT.NOIDUNGTTGQ;
                    //        if (oLoadCT.TTGQ == 2)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbYCBS.Visible = true;
                    //        }
                    //        if (oLoadCT.TTGQ == 3)
                    //        {
                    //            txtYCBS.Visible = true;
                    //            //lbLDTL.Visible = true;
                    //        }
                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    //else
                    //{
                    DON_KHAC oLoadDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //if (oLoadDK.TTGQ != null)
                    //{
                    //rdTTGQ.SelectedValue = oLoadDK.TTGQ.ToString();
                    txtYCBS.Text = oLoadDK.NOIDUNGTTGQ;
                    //        txtYCBS.Visible = true;
                    //    }
                    //    else
                    //    {
                    //        //rdTTGQ.SelectedValue = "1";
                    //    }
                    //}
                    decimal donid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                    APS_DON oD = dt.APS_DON.Where(x => x.ID == donid).FirstOrDefault();
                    if (oD.QUANHEPHAPLUAT_NAME != null)
                    {
                        txtQHPL.Text = oD.QUANHEPHAPLUAT_NAME;
                    }
                    else if (oD.QUANHEPHAPLUATID != null && oD.QUANHEPHAPLUATID != 0)
                    {
                        decimal IDQHPL = Convert.ToDecimal(oD.QUANHEPHAPLUATID.ToString());
                        DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                        if (obj != null)
                            txtQHPL.Text = obj.TEN.ToString();
                    }
                    else
                        txtQHPL.Text = null;

                    if (LOAIDON == 1 || LOAIDON == 2 || LOAIDON == 3 || LOAIDON == 4)
                    {
                        APS_DON_DUONGSU oND = null;
                        APS_DON_DUONGSU oBD = null;
                        List<DON_DUONGSU_CHITIET> oListDs = dt.DON_DUONGSU_CHITIET.Where(x => x.DONCHITIETID == DONGHEPID).ToList();
                        for (int i = 0; i < oListDs.Count; i++)
                        {
                            int IDduongSu = Convert.ToInt32(oListDs[i].DUONGSUID);
                            APS_DON_DUONGSU Ods = dt.APS_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            if (Ods.TUCACHTOTUNG_MA == "NGUYENDON")
                            {
                                oND = dt.APS_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                            if (Ods.TUCACHTOTUNG_MA == "BIDON")
                            {
                                oBD = dt.APS_DON_DUONGSU.Where(x => x.ID == IDduongSu).FirstOrDefault();
                            }
                        }
                        if (oListDs.Count > 0)
                        {
                            if (oND != null)
                            {
                                txtTennguyendon.Text = oND.TENDUONGSU;
                                txtCMND_ND.Text = oND.SOCMND;
                            }
                            if (oBD != null)
                            {
                                txtTenbidon.Text = oBD.TENDUONGSU;
                                txtCMND_BD.Text = oBD.SOCMND;
                            }


                        }
                    }
                    else if (LOAIDON == 5 || LOAIDON == 6)
                    {
                        string NguoiYeuCau = "";
                        try
                        {
                            var data = (from s in dt.DON_DUONGSU_CHITIET
                                        join d in dt.APS_DON_DUONGSU on s.DUONGSUID equals d.ID
                                        where s.DONCHITIETID == DONGHEPID
                                        select new
                                        {
                                            d.TENDUONGSU
                                        });
                            foreach (var item in data)
                            {
                                NguoiYeuCau = NguoiYeuCau + " " + item.TENDUONGSU + ",";
                            }
                            txtNguoiyeucau.Text = NguoiYeuCau.TrimEnd(',');
                        }
                        catch { }
                    }
                    else if (LOAIDON == 7)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                APS_DON_DUONGSU oDKDS = dt.APS_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                APS_DON_THAMGIATOTUNG oDKTGTT = dt.APS_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoikhangcao.Text = oDKTGTT.HOTEN;
                            }
                        }

                    }
                    else if (LOAIDON == 8)
                    {
                        DON_KHAC oDK = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDK != null)
                        {
                            if (oDK.ISDUONGSU == 1)
                            {
                                APS_DON_DUONGSU oDKDS = dt.APS_DON_DUONGSU.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKDS.TENDUONGSU;
                            }
                            else if (oDK.ISDUONGSU == 0)
                            {
                                APS_DON_THAMGIATOTUNG oDKTGTT = dt.APS_DON_THAMGIATOTUNG.Where(x => x.ID == oDK.DUONGSUID).FirstOrDefault();
                                txtNguoidungdon.Text = oDKTGTT.HOTEN;
                            }
                        }
                    }
                }


                if (LOAIAN != 3)
                {
                    if (LOAIDON == 5 || LOAIDON == 6)
                    {
                        txtNguoiyeucau.Visible = true;
                        lbNguoiyeucau.Visible = true;
                    }
                    else if (LOAIDON == 7)
                    {
                        txtNguoikhangcao.Visible = true;
                        lbNguoikhangcao.Visible = true;
                    }
                    else if (LOAIDON == 8)
                    {
                        txtNguoidungdon.Visible = true;
                        lbNguoidungdon.Visible = true;
                        //rdTTGQ.Visible = false;
                    }
                    else
                    {
                        pnNDBD.Visible = true;
                    }
                }
                else if (LOAIAN == 3)
                {
                    if (LOAIDON == 8 || LOAIDON == 9)
                    {
                        txtNguoiyeucau.Visible = true;
                        lbNguoiyeucau.Visible = true;
                    }
                    else if (LOAIDON == 10)
                    {
                        txtNguoikhangcao.Visible = true;
                        lbNguoikhangcao.Visible = true;
                    }
                    else if (LOAIDON == 11)
                    {
                        txtNguoidungdon.Visible = true;
                        lbNguoidungdon.Visible = true;
                    }
                    else
                    {
                        pnNDBD.Visible = true;
                    }
                }
            }


        }

        protected void ddlLoaidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal LOAIDON = Convert.ToDecimal(Request.QueryString["LOAIDON"]);
            if (ddlLoaidon.SelectedValue == "7")
            {
                pnNDBD.Visible = false;
                lbNguoikhangcao.Visible = true;
                txtNguoikhangcao.Visible = true;
            }
            else if (ddlLoaidon.SelectedValue == "8")
            {
                pnNDBD.Visible = false;
                lbNguoidungdon.Visible = true;
                txtNguoidungdon.Visible = true;
                txtYCBS.Visible = true;
            }
            else if (ddlLoaidon.SelectedValue == "5" && ddlLoaidon.SelectedValue == "6")
            {
                pnNDBD.Visible = false;
                lbNguoiyeucau.Visible = true;
                txtNguoiyeucau.Visible = true;
            }
            else
            {
                pnNDBD.Visible = true;
                txtNguoidungdon.Visible = false;
                txtNguoikhangcao.Visible = false;
                txtNguoiyeucau.Visible = false;
                txtYCBS.Visible = false;
                txtYCBS.Text = "";
                lbNguoiyeucau.Visible = false;
                lbNguoikhangcao.Visible = false;
                lbNguoidungdon.Visible = false;
                //lbLDTL.Visible = false;
                //lbYCBS.Visible = false;
            }
        }

        protected void ddlLoaidonHN_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal LOAIDON = Convert.ToDecimal(Request.QueryString["LOAIDON"]);
            if (ddlLoaidon.SelectedValue == "10")
            {
                pnNDBD.Visible = false;
                lbNguoikhangcao.Visible = true;
                txtNguoikhangcao.Visible = true;
            }
            else if (ddlLoaidon.SelectedValue == "11")
            {
                pnNDBD.Visible = false;
                lbNguoidungdon.Visible = true;
                txtNguoidungdon.Visible = true;
            }
            else if (ddlLoaidon.SelectedValue == "8" && ddlLoaidon.SelectedValue == "9")
            {
                pnNDBD.Visible = false;
                lbNguoiyeucau.Visible = true;
                txtNguoiyeucau.Visible = true;
            }
            else
            {
                pnNDBD.Visible = true;
                txtNguoidungdon.Visible = false;
                txtNguoikhangcao.Visible = false;
                txtNguoiyeucau.Visible = false;
                txtYCBS.Visible = false;
                txtYCBS.Text = "";
                lbNguoiyeucau.Visible = false;
                lbNguoikhangcao.Visible = false;
                lbNguoidungdon.Visible = false;
                //lbLDTL.Visible = false;
                //lbYCBS.Visible = false;
            }
        }

        //protected void rdTTGQ_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (rdTTGQ.SelectedValue == "2")
        //    {
        //        lbYCBS.Visible = true;
        //        txtYCBS.Visible = true;
        //        lbLDTL.Visible = false;
        //        txtYCBS.Text = "";
        //    }
        //    else if (rdTTGQ.SelectedValue == "3")
        //    {
        //        lbLDTL.Visible = true;
        //        lbYCBS.Visible = false;
        //        txtYCBS.Visible = true;
        //        txtYCBS.Text = "";
        //    }
        //    else
        //    {
        //        lbYCBS.Visible = false;
        //        txtYCBS.Visible = false;
        //        lbLDTL.Visible = false;
        //        txtYCBS.Visible = false;
        //        txtYCBS.Text = "";

        //    }
        //}

        private bool SaveData()
        {
            try
            {
                //if (rdTTGQ.SelectedValue == "2")
                //{
                //    if (txtYCBS.Text == "")
                //    {
                //        lstMsgB.Text = "Bạn chưa nhập yêu cầu bổ sung";
                //        txtYCBS.Focus();
                //        return false;
                //    }

                //}
                //else if (rdTTGQ.SelectedValue == "3")
                //{
                //    if (txtYCBS.Text == "")
                //    {
                //        lstMsgB.Text = "Bạn chưa nhập lý do trả lại";
                //        txtYCBS.Focus();
                //        return false;
                //    }
                //}
                if (txtYCBS.Text == "")
                {
                    lstMsgB.Text = "Bạn chưa nhập kết quả xử lý";
                    txtYCBS.Focus();
                    return false;
                }

                decimal DONGHEPID = Convert.ToDecimal(Request.QueryString["DONGHEPID"]);
                decimal LOAIDON = Convert.ToDecimal(Request.QueryString["LOAIDON"]);
                decimal LOAIAN = Convert.ToDecimal(Request.QueryString["LOAIAN"]);
                if (LOAIAN != 3)
                {
                    //if (LOAIDON != 7 && LOAIDON != 8)
                    //{
                    //    DON_CHITIET oDCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    //    if (oDCT != null)
                    //    {
                    //        //oDCT.TTGQ = Convert.ToDecimal(rdTTGQ.SelectedValue);
                    //        oDCT.NOIDUNGTTGQ = txtYCBS.Text;
                    //        dt.SaveChanges();
                    //    }
                    //}
                    //else
                    //{
                    DON_KHAC oDCT = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                    if (oDCT != null)
                    {
                        //oDCT.TTGQ = Convert.ToDecimal(rdTTGQ.SelectedValue);
                        oDCT.NOIDUNGTTGQ = txtYCBS.Text;
                        dt.SaveChanges();
                    }
                    //}
                }
                else if (LOAIAN == 3)
                {
                    if (LOAIDON != 10 && LOAIDON != 11)
                    {
                        DON_CHITIET oDCT = dt.DON_CHITIET.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDCT != null)
                        {
                            //oDCT.TTGQ = Convert.ToDecimal(rdTTGQ.SelectedValue);
                            oDCT.NOIDUNGTTGQ = txtYCBS.Text;
                            dt.SaveChanges();
                        }
                    }
                    else
                    {
                        DON_KHAC oDCT = dt.DON_KHAC.Where(x => x.ID == DONGHEPID && x.LOAIANID == LOAIAN).FirstOrDefault();
                        if (oDCT != null)
                        {
                            //oDCT.TTGQ = Convert.ToDecimal(rdTTGQ.SelectedValue);
                            oDCT.NOIDUNGTTGQ = txtYCBS.Text;
                            dt.SaveChanges();
                        }
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                lstMsgB.Text = "Lưu thông tin đơn thành công !";
                //Session["DS_THEMDSK"] = hddID.Value;

            }
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
    }
}
