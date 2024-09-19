/*
 * Copyright 2010-2024 JetBrains s.r.o. and Kotlin Programming Language contributors.
 * Use of this source code is governed by the Apache 2.0 license that can be found in the license/LICENSE.txt file.
 */

package org.jetbrains.kotlin.analysis.decompiled.light.classes;

import com.intellij.testFramework.TestDataPath;
import org.jetbrains.kotlin.test.util.KtTestUtil;
import org.jetbrains.kotlin.test.TestMetadata;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.regex.Pattern;

/** This class is generated by {@link org.jetbrains.kotlin.generators.tests.analysis.api.GenerateAnalysisApiTestsKt}. DO NOT MODIFY MANUALLY */
@SuppressWarnings("all")
@TestMetadata("analysis/decompiled/light-classes-for-decompiled/testData/blub")
@TestDataPath("$PROJECT_ROOT")
public class BlubTestGenerated extends AbstractBlubTest {
  @Test
  public void testAllFilesPresentInBlub() {
    KtTestUtil.assertAllTestsPresentByMetadataWithExcluded(this.getClass(), new File("analysis/decompiled/light-classes-for-decompiled/testData/blub"), Pattern.compile("^(.+)\\.kt$"), null, true);
  }

  @Test
  @TestMetadata("multifileClass.kt")
  public void testMultifileClass() {
    runTest("analysis/decompiled/light-classes-for-decompiled/testData/blub/multifileClass.kt");
  }

  @Test
  @TestMetadata("multifileClassInherited.kt")
  public void testMultifileClassInherited() {
    runTest("analysis/decompiled/light-classes-for-decompiled/testData/blub/multifileClassInherited.kt");
  }

  @Test
  @TestMetadata("simple.kt")
  public void testSimple() {
    runTest("analysis/decompiled/light-classes-for-decompiled/testData/blub/simple.kt");
  }
}
