<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pTachAn.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.Hoso.Popup.pTachAn" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Nhập án</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <style>
            body {
                width: 98%;
                margin-left: 1%;
                min-width: 0px;
                overflow: auto;
            }
            .boxchung {
                margin: 5px 0;
                width: 100%;
                display: inline-block;
                position: relative;
                float: left;
            }
            .boxchung_body{
                border: 1px solid #c5c5c5;
                border-radius: 5px 5px 5px 5px;
                padding: 10px 1%;
                float: left;
                width: 98%;
                margin-top: 10px;
                padding-top: 20px;
                z-index: 2;
                float: left;
            }
            .tleboxchung {
                position: absolute;
                margin-left: 15px;
                background: #ffe869;
                z-index: 2;
                padding: 0 2px;
                white-space: nowrap;
                border: solid 1px #dcdcdc;
                padding: 5px 10px;
                border-radius: 10px;
                font-weight: bold;
                text-transform: uppercase;
            }
            .cssMargin{
               margin-bottom: 30px;
            }
        </style>

        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:HiddenField ID="hddTotalPage_Khac" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex_Khac" Value="1" runat="server" />
        
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin vụ việc gốc</h4>
                <div class="boxchung_body">
                    <asp:DataGrid ID="dgVuAnGoc" runat="server" AutoGenerateColumns="False" CellPadding="4"
                        PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>
                                    Thông tin vụ việc
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID") %>' />

                                    <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                    <br />
                                    <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                    <%#Eval("TruongHopGiaoNhan")%>
                                    <%# Eval("TENTOASOTHAM")%>
                                    <%#Eval("BANAN_QD_ST")%>
                                    <%#Eval("HoTenBiCan")%>
                                    <%#Eval("KHANGNGHI_ST")%>
                                    <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:BoundColumn DataField="TINHTRANG_GQ" HeaderText="Tình trạng GQ"
                                HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left"
                                HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left" HeaderStyle-Width="65px">
                                <HeaderTemplate>
                                    Người tạo
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("NGUOITAO")%>
                                    <br />
                                    <%#Eval("NGAYTAO")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="50px" HeaderStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Mã vụ việc
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("MAVUVIEC")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                    </asp:DataGrid>
                </div>
            </div>

            <div class="boxchung">
                <h4 class="tleboxchung">Danh sách đơn</h4>
                <div class="boxchung_body">
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                        </div>
                    </div>
                    <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" 
                        PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" 
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>TT</HeaderTemplate>
                                <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Vụ tách</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' runat="server" OnCheckedChanged="chkChon_CheckedChanged" AutoPostBack="true"/>
                                    <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID") %>' />
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Đại diện</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkChonDaiDien" Visible="false" ToolTip='<%#Eval("ID")%>' runat="server" OnCheckedChanged="chkChonDaiDien_CheckedChanged" AutoPostBack="true"/>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="180px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Loại đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("LOAIDON")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Người nộp đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TENNGUOINOP")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Tư cách tố tụng</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TCTT")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>CMND/CCCD/Hộ chiếu</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("SOCMND")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"  HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Right">
                                <HeaderTemplate>Năm sinh</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("NAMSINH")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center"  HeaderStyle-Width="85px" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Ngày ghi trên đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%# string.Format("{0:dd/MM/yyyy}",Eval("NGAYGHITRENDON")) %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Nội dung</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("NOIDUNGKHOIKIEN")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>

            <div class="boxchung">
                <h4 class="tleboxchung">Danh sách đơn khác</h4>
                <div class="boxchung_body">
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT_Khac" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack_Khac" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst_Khac" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Khac_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1_Khac" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTStep2_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6_Khac" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTLast_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext_Khac" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Khac_Click"></asp:LinkButton>
                        </div>
                    </div>
                    <asp:DataGrid ID="dgListKhac" runat="server" AutoGenerateColumns="False" CellPadding="4" 
                        PageSize="10" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages" 
                        CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                        ItemStyle-CssClass="chan" Width="100%">
                        <Columns>
                            <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                            <asp:TemplateColumn HeaderStyle-Width="15px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>TT</HeaderTemplate>
                                <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Chọn</HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkChonKhac" ToolTip='<%#Eval("ID")%>' runat="server" />
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Loại đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("LOAIDON")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Người nộp đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TENNGUOINOP")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Tư cách tố tụng</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TCTT")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>CMND/ CCCD/ Hộ chiếu</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("SOCMND")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Right">
                                <HeaderTemplate>Năm sinh</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("NAMSINH")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="85px" ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>Ngày ghi trên đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%# Eval("NGAYGHITRENDON") %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Nội dung đơn</HeaderTemplate>
                                <ItemTemplate>
                                    <%# Eval("NOIDUNGKHOIKIEN") %>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                            <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" ItemStyle-HorizontalAlign="Left">
                                <HeaderTemplate>Tình trạng giải quyết</HeaderTemplate>
                                <ItemTemplate>
                                    <%#Eval("TTGQ")%>
                                </ItemTemplate>
                            </asp:TemplateColumn>
                        </Columns>
                        <HeaderStyle CssClass="header"></HeaderStyle>
                        <ItemStyle CssClass="chan"></ItemStyle>
                        <PagerStyle Visible="false"></PagerStyle>
                    </asp:DataGrid>
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiB_Khac" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack_Khac" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst_Khac" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Khac_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep1_Khac" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBStep2_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Khac_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6_Khac" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBLast_Khac" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Khac_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext_Khac" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Khac_Click"></asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>

            <table class="table1">
                <tr>
                    <td colspan="2" align="left">
                        <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2">
                        <asp:Button ID="cmdTachAn" runat="server" CssClass="buttoninput cssMargin" Text="Tách án" OnClick="cmdTachAn_Click"/>
                    </td>
                </tr>
            </table>
        </div>

        <script type="text/javascript">
            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }

            //Khi tách án thành công
            function OnClose() {
                //Gọi đến function của windown parent
                if (window.opener != null && !window.opener.closed) {
                    window.opener.HideModalDivTachAn();
                }
                window.close();
            }

            //Khi đóng popup
            $(window).on("beforeunload", function () {
                return window.opener.HideModalDiv();
            })
        </script>
    </form>
</body>
</html>
