/// Signature for the callback that reports the custom renderer has been extended
/// and set to the gauge axis
typedef GaugeAxisRendererFactory<GaugeAxisRenderer> = GaugeAxisRenderer
    Function();

/// Signature for the callback that reports the custom renderer has been extended
/// and set to the marker pointer
typedef MarkerPointerRendererFactory<MarkerPointerRenderer>
    = MarkerPointerRenderer Function();

/// Signature for the callback that report the custom renderer has been extended
/// and set to the needle pointer
typedef NeedlePointerRendererFactory<NeedlePointerRenderer>
    = NeedlePointerRenderer Function();
